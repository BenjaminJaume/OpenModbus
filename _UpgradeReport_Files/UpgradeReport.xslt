<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
  <xsl:output omit-xml-declaration="yes"/>

  <!-- Keys -->
  <xsl:key name="ProjectKey" match="Event" use="@Project"/>

  <!-- String split template -->
  <xsl:template name="SplitString">
    <xsl:param name="source" select="''"/>
    <xsl:param name="separator" select="','"/>
    <xsl:if test="not($source = '' or $separator = '')">
      <xsl:variable name="head" select="substring-before(concat($source, $separator), $separator)"/>
      <xsl:variable name="tail" select="substring-after($source, $separator)"/>
      <part>
        <xsl:value-of select="$head"/>
      </part>
      <xsl:call-template name="SplitString">
        <xsl:with-param name="source" select="$tail"/>
        <xsl:with-param name="separator" select="$separator"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Intermediate Templates -->
  <xsl:template match="UpgradeReport" mode="ProjectOverviewXML">
    <Projects>
      <xsl:for-each select="Event[generate-id(.) = generate-id(key('ProjectKey', @Project))]">
        <Project>
          <xsl:variable name="pNode" select="current()"/>
          <xsl:variable name="errorCount" select="count(../Event[@Project = current()/@Project and @ErrorLevel=2])"/>
          <xsl:variable name="warningCount" select="count(../Event[@Project = current()/@Project and @ErrorLevel=1])"/>
          <xsl:variable name="messageCount" select="count(../Event[@Project = current()/@Project and @ErrorLevel=0])"/>
          <xsl:variable name="pathSplitSeparator">
            <xsl:text>\</xsl:text>
          </xsl:variable>
          <xsl:variable name="projectName">
            <xsl:choose>
              <xsl:when test="@Project = ''">Solution</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@Project"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:attribute name="IsSolution">
            <xsl:value-of select="@Project = ''"/>
          </xsl:attribute>
          <xsl:attribute name="Project">
            <xsl:value-of select="$projectName"/>
          </xsl:attribute>
          <xsl:attribute name="ProjectDisplayName">

            <xsl:variable name="localProjectName" select="@Project"/>

            <!-- Sometimes it is possible to have project name set to a path over a real project name,
                 we split the string on '\' and if we end up with >1 part in the resulting tokens set
                 we format the ProjectDisplayName as ..\prior\last -->
            <xsl:variable name="pathTokens">
              <xsl:call-template name="SplitString">
                <xsl:with-param name="source" select="$localProjectName"/>
                <xsl:with-param name="separator" select="$pathSplitSeparator"/>
              </xsl:call-template>
            </xsl:variable>

            <xsl:choose>
              <xsl:when test="count(msxsl:node-set($pathTokens)/part) &gt; 1">
                <xsl:value-of select="concat('..', $pathSplitSeparator, msxsl:node-set($pathTokens)/part[last() - 1], $pathSplitSeparator, msxsl:node-set($pathTokens)/part[last()])"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$localProjectName"/>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:attribute>
          <xsl:attribute name="ProjectSafeName">
            <xsl:value-of select="translate($projectName, '\', '-')"/>
          </xsl:attribute>
          <xsl:attribute name="Solution">
            <xsl:value-of select="/UpgradeReport/Properties/Property[@Name='Solution']/@Value"/>
          </xsl:attribute>
          <xsl:attribute name="Source">
            <xsl:value-of select="@Source"/>
          </xsl:attribute>
          <xsl:attribute name="Status">
            <xsl:choose>
              <xsl:when test="$errorCount &gt; 0">Error</xsl:when>
              <xsl:when test="$warningCount &gt; 0">Warning</xsl:when>
              <xsl:otherwise>Success</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="ErrorCount">
            <xsl:value-of select="$errorCount"/>
          </xsl:attribute>
          <xsl:attribute name="WarningCount">
            <xsl:value-of select="$warningCount"/>
          </xsl:attribute>
          <xsl:attribute name="MessageCount">
            <xsl:value-of select="$messageCount"/>
          </xsl:attribute>
          <xsl:attribute name="TotalCount">
            <xsl:value-of select="$errorCount + $warningCount + $messageCount"/>
          </xsl:attribute>
          <xsl:for-each select="../Event[@Project = $pNode/@Project and @ErrorLevel=3]">
            <ConversionStatus>
              <xsl:value-of select="@Description"/>
            </ConversionStatus>
          </xsl:for-each>
          <Messages>
            <xsl:for-each select="../Event[@Project = $pNode/@Project and @ErrorLevel&lt;3]">
              <Message>
                <xsl:attribute name="Level">
                  <xsl:value-of select="@ErrorLevel"/>
                </xsl:attribute>
                <xsl:attribute name="Status">
                  <xsl:choose>
                    <xsl:when test="@ErrorLevel = 0">Message</xsl:when>
                    <xsl:when test="@ErrorLevel = 1">Warning</xsl:when>
                    <xsl:when test="@ErrorLevel = 2">Error</xsl:when>
                    <xsl:otherwise>Message</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="Source">
                  <xsl:value-of select="@Source"/>
                </xsl:attribute>
                <xsl:attribute name="Message">
                  <xsl:value-of select="@Description"/>
                </xsl:attribute>
              </Message>
            </xsl:for-each>
          </Messages>
        </Project>
      </xsl:for-each>
    </Projects>
  </xsl:template>



  <!-- Project Overview template -->
  <xsl:template match="Projects" mode="ProjectOverview">

    <table>
      <tr>
        <th></th>
        <th _locID="ProjectTableHeader">Projet</th>
        <th _locID="PathTableHeader">Chemin d'accès</th>
        <th _locID="ErrorsTableHeader">Erreurs</th>
        <th _locID="WarningsTableHeader">Avertissements</th>
        <th _locID="MessagesTableHeader">Messages</th>
      </tr>

      <xsl:for-each select="Project">

        <xsl:sort select="@ErrorCount" order="descending"/>
        <xsl:sort select="@WarningCount" order="descending"/>
        <!-- Always make solution last within a group -->
        <xsl:sort select="@IsSolution" order="ascending"/>
        <xsl:sort select="@ProjectSafeName" order="ascending"/>

        <tr>
          <td>
              <xsl:attribute name="class">
                <xsl:choose>
                  <xsl:when test="@Status = 'Error'">IconErrorEncoded</xsl:when>
                  <xsl:when test="@Status = 'Warning'">IconWarningEncoded</xsl:when>
                  <xsl:when test="@Status = 'Success'">IconSuccessEncoded</xsl:when>
                </xsl:choose>
              </xsl:attribute>
          </td>
          <td>
            <strong>
              <a>
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('#', @ProjectSafeName)"/>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="@ProjectDisplayName = ''">
                    <span _locID="OverviewSolutionSpan">Solution</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="@ProjectDisplayName"/>
                  </xsl:otherwise>
                </xsl:choose>
              </a>
            </strong>
          </td>
          <td>
            <xsl:value-of select="@Source"/>
          </td>
          <td class="textCentered">
            <a>
              <xsl:if test="@ErrorCount &gt; 0">
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('#', @ProjectSafeName, 'Error')"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="@ErrorCount"/>
            </a>
          </td>
          <td class="textCentered">
            <a>
              <xsl:if test="@WarningCount &gt; 0">
                <xsl:attribute name="href">
                  <xsl:value-of select="concat('#', @ProjectSafeName, 'Warning')"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="@WarningCount"/>
            </a>
          </td>
          <td class="textCentered">
            <a href="#">
              <xsl:if test="@MessageCount &gt; 0">
                <xsl:attribute name="onclick">
                  <xsl:variable name="apos">
                    <xsl:text>'</xsl:text>
                  </xsl:variable>
                  <xsl:variable name="JS" select="concat('ScrollToFirstVisibleMessage(', $apos, @ProjectSafeName, $apos, ')')"/>
                  <xsl:value-of select="concat($JS, '; return false;')"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:value-of select="@MessageCount"/>
            </a>
          </td>
        </tr>
      </xsl:for-each>
    </table>
  </xsl:template>

  <!-- Show messages row -->
  <xsl:template match="Project" mode="ProjectShowMessages">
    <tr>
      <xsl:attribute name="name">
        <xsl:value-of select="concat('MessageRowHeaderShow', @ProjectSafeName)"/>
      </xsl:attribute>
      <td class="IconInfoEncoded"/>
      <td class="messageCell">
        <xsl:variable name="apos">
          <xsl:text>'</xsl:text>
        </xsl:variable>
        <xsl:variable name="toggleRowsJS" select="concat('ToggleMessageVisibility(', $apos, @ProjectSafeName, $apos, ')')"/>

        <a _locID="ShowAdditionalMessages" href="#">
          <xsl:attribute name="name">
            <xsl:value-of select="concat(@ProjectSafeName, 'Message')"/>
          </xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:value-of select="concat($toggleRowsJS, '; return false;')"/>
          </xsl:attribute>
          Afficher <xsl:value-of select="@MessageCount"/> messages supplémentaires
        </a>
      </td>
    </tr>
  </xsl:template>

  <!-- Hide messages row -->
  <xsl:template match="Project" mode="ProjectHideMessages">
    <tr style="display: none">
      <xsl:attribute name="name">
        <xsl:value-of select="concat('MessageRowHeaderHide', @ProjectSafeName)"/>
      </xsl:attribute>
      <td class="IconInfoEncoded"/>
      <td class="messageCell">
        <xsl:variable name="apos">
          <xsl:text>'</xsl:text>
        </xsl:variable>
        <xsl:variable name="toggleRowsJS" select="concat('ToggleMessageVisibility(', $apos, @ProjectSafeName, $apos, ')')"/>

        <a _locID="HideAdditionalMessages" href="#">
          <xsl:attribute name="name">
            <xsl:value-of select="concat(@ProjectSafeName, 'Message')"/>
          </xsl:attribute>
          <xsl:attribute name="onclick">
            <xsl:value-of select="concat($toggleRowsJS, '; return false;')"/>
          </xsl:attribute>
          Masquer <xsl:value-of select="@MessageCount"/> messages supplémentaires
        </a>
      </td>
    </tr>
  </xsl:template>

  <!-- Message row templates -->
  <xsl:template match="Message">
    <tr>
      <xsl:attribute name="name">
        <xsl:value-of select="concat(@Status, 'RowClass', ../../@ProjectSafeName)"/>
      </xsl:attribute>

      <xsl:if test="@Level = 0">
        <xsl:attribute name="style">display: none</xsl:attribute>
      </xsl:if>
      <td>
        <xsl:attribute name="class">
        <xsl:choose>
            <xsl:when test="@Status = 'Error'">IconErrorEncoded</xsl:when>
            <xsl:when test="@Status = 'Warning'">IconWarningEncoded</xsl:when>
            <xsl:when test="@Status = 'Message'">IconInfoEncoded</xsl:when>
        </xsl:choose>
        </xsl:attribute>
        <a>
          <xsl:attribute name="name">
            <xsl:value-of select="concat(../../@ProjectSafeName, @Status)"/>
          </xsl:attribute>
        </a>
      </td>
      <td class="messageCell">
        <strong>
          <xsl:value-of select="@Source"/>:
        </strong>
        <span>
          <xsl:value-of select="@Message"/>
        </span>
      </td>
    </tr>
  </xsl:template>

  <!-- Project Details Template -->
  <xsl:template match="Projects" mode="ProjectDetails">

    <xsl:for-each select="Project">
      <xsl:sort select="@ErrorCount" order="descending"/>
      <xsl:sort select="@WarningCount" order="descending"/>
      <!-- Always make solution last within a group -->
      <xsl:sort select="@IsSolution" order="ascending"/>
      <xsl:sort select="@ProjectSafeName" order="ascending"/>

      <a>
        <xsl:attribute name="name">
          <xsl:value-of select="@ProjectSafeName"/>
        </xsl:attribute>
      </a>
      <xsl:choose>
        <xsl:when test="@ProjectDisplayName = ''">
          <h3 _locID="ProjectDisplayNameHeader">Solution</h3>
        </xsl:when>
        <xsl:otherwise>
          <h3>
            <xsl:value-of select="@ProjectDisplayName"/>
          </h3>
        </xsl:otherwise>
      </xsl:choose>

      <table>
        <tr>
          <xsl:attribute name="id">
            <xsl:value-of select="concat(@ProjectSafeName, 'HeaderRow')"/>
          </xsl:attribute>
          <th></th>
          <th class="messageCell" _locID="MessageTableHeader">Message</th>
        </tr>

        <!-- Errors and warnings -->
        <xsl:for-each select="Messages/Message[@Level &gt; 0]">
          <xsl:sort select="@Level" order="descending"/>
          <xsl:apply-templates select="."/>
        </xsl:for-each>

        <xsl:if test="@MessageCount &gt; 0">
          <xsl:apply-templates select="." mode="ProjectShowMessages"/>
        </xsl:if>

        <!-- Messages -->
        <xsl:for-each select="Messages/Message[@Level = 0]">
          <xsl:apply-templates select="."/>
        </xsl:for-each>

        <xsl:choose>
          <!-- Additional row as a 'place holder' for 'Show/Hide' additional messages -->
          <xsl:when test="@MessageCount &gt; 0">
            <xsl:apply-templates select="." mode="ProjectHideMessages"/>
          </xsl:when>
          <!-- No messages at all, show blank row -->
          <xsl:when test="@TotalCount = 0">
            <tr>
              <td class="IconInfoEncoded"/>
              <xsl:choose>
                <xsl:when test="@ProjectDisplayName = ''">
                  <td class="messageCell" _locID="NoMessagesRow2">
                    La solution n'a consigné aucun message dans le journal.
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td class="messageCell" _locID="NoMessagesRow">
                    <xsl:value-of select="@ProjectDisplayName"/> n'a consigné aucun message dans le journal.
                  </td>
                </xsl:otherwise>
              </xsl:choose>
            </tr>
          </xsl:when>
        </xsl:choose>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- Document, matches "UpgradeReport" -->
  <xsl:template match="UpgradeReport">
    <!-- Output doc type the 'Mark of the web' which disabled prompting to run JavaScript from local HTML Files in IE -->
    <!-- NOTE: The whitespace around the 'Mark of the web' is important it must be exact -->
    <xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html>
<!-- saved from url=(0014)about:internet -->
]]>
    </xsl:text>
    <html>
      <head>
        <meta content="en-us" http-equiv="Content-Language"/>
        <meta content="text/html; charset=utf-16" http-equiv="Content-Type"/>
        <title _locID="ConversionReport0">
          Rapport de migration
        </title>
        <style>
            <xsl:text disable-output-escaping="yes">
                <![CDATA[
                    /* Body style, for the entire document */
                    body
                    {
                        background: #F3F3F4;
                        color: #1E1E1F;
                        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
                        padding: 0;
                        margin: 0;
                    }

                    /* Header1 style, used for the main title */
                    h1
                    {
                        padding: 10px 0px 10px 10px;
                        font-size: 21pt;
                        background-color: #E2E2E2;
                        border-bottom: 1px #C1C1C2 solid; 
                        color: #201F20;
                        margin: 0;
                        font-weight: normal;
                    }

                    /* Header2 style, used for "Overview" and other sections */
                    h2
                    {
                        font-size: 18pt;
                        font-weight: normal;
                        padding: 15px 0 5px 0;
                        margin: 0;
                    }

                    /* Header3 style, used for sub-sections, such as project name */
                    h3
                    {
                        font-weight: normal;
                        font-size: 15pt;
                        margin: 0;
                        padding: 15px 0 5px 0;
                        background-color: transparent;
                    }

                    /* Color all hyperlinks one color */
                    a
                    {
                        color: #1382CE;
                    }

                    /* Table styles */ 
                    table
                    {
                        border-spacing: 0 0;
                        border-collapse: collapse;
                        font-size: 10pt;
                    }

                    table th
                    {
                        background: #E7E7E8;
                        text-align: left;
                        text-decoration: none;
                        font-weight: normal;
                        padding: 3px 6px 3px 6px;
                    }

                    table td
                    {
                        vertical-align: top;
                        padding: 3px 6px 5px 5px;
                        margin: 0px;
                        border: 1px solid #E7E7E8;
                        background: #F7F7F8;
                    }

                    /* Local link is a style for hyperlinks that link to file:/// content, there are lots so color them as 'normal' text until the user mouse overs */
                    .localLink
                    {
                        color: #1E1E1F;
                        background: #EEEEED;
                        text-decoration: none;
                    }

                    .localLink:hover
                    {
                        color: #1382CE;
                        background: #FFFF99;
                        text-decoration: none;
                    }

                    /* Center text, used in the over views cells that contain message level counts */ 
                    .textCentered
                    {
                        text-align: center;
                    }

                    /* The message cells in message tables should take up all avaliable space */
                    .messageCell
                    {
                        width: 100%;
                    }

                    /* Padding around the content after the h1 */ 
                    #content 
                    {
	                    padding: 0px 12px 12px 12px; 
                    }

                    /* The overview table expands to width, with a max width of 97% */ 
                    #overview table
                    {
                        width: auto;
                        max-width: 75%; 
                    }

                    /* The messages tables are always 97% width */
                    #messages table
                    {
                        width: 97%;
                    }

                    /* All Icons */
                    .IconSuccessEncoded, .IconInfoEncoded, .IconWarningEncoded, .IconErrorEncoded
                    {
                        min-width:18px;
                        min-height:18px; 
                        background-repeat:no-repeat;
                        background-position:center;
                    }

                    /* Success icon encoded */
                    .IconSuccessEncoded
                    {
                        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAABOElEQVR4XqVTIWvDQBh9HVWBwWzEYGow19KpQiBqrqKiYqpVkf0BcTX9ASdr2jBZMRFRe1CYysjcYDAoTIS5wCB6eXAXsjt2YezBme/73vfeF156MFBV1QLAHEBotCSAxPO8HVo4axGv6pfnn/k2lnEYPARoP9bY4wxnoUAHUIV8/bS+OLwf4MLsZobl7bIEMKzdnLSDR5GJTjKxf92Ds+SAJ/Dm2tqAjd8wuZ4gizKk92mzhBxy6WDOggvRKAKxed78cEIuF4THj6NT3T/3UXwVSN9SaChOyAV/ULfRhwHeScWVXIEw1C2YDqiklTvV9QIZXAZQoBIVqexUVxzJBQnDYbuAU11xEp1EpnBgBcmdxpc6iUOdxGk8jkvDSVeUp81HZKaZbW4Vd0LdZ9/MHmc4qzj49+/8DReTp9S7vY7uAAAAAElFTkSuQmCC);
                    }

                    /* Information icon encoded */
                    .IconInfoEncoded
                    {
                        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAABBElEQVR4Xs2TsYrCQBCG1wVFo3DXWHkHNvZJIdem8AXiA5i8xRXWFvcWiVibF7BIKxamtwmolY2FxsNrnF9GiVkSCGnuh2GL2e9nZvm3IlKK49ihw6YyU62AytM0zU0ClQTYpcNfHv50d3MRi/31hR50asLpNcRXuxoSYJFRxAZPeP29Or3Po1+RJ5iM9eaRMAMmkhv+JDwr8G70ea+kMB3uggEosfNj7BwpJmDAYgI7C/6YblGZJmBhYKYfTF1BFTOmFCX1PwwChKSomAlg4CEcRcWMJ5FtxHPYrReCwYCVDFg//dYRjcwcqFG2no/IH8OgRjgz33g/dWf0cAd3mRGlv/MNZL1xS4xD8eEAAAAASUVORK5CYII=);
                    }

                    /* Warning icon encoded */
                    .IconWarningEncoded
                    {
                        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAx0lEQVR4XpWSMQ7CMAxFf4xAyBMLCxMrO8dhaBcuwdCJS3RJBw7SA/QGTCxdWJgiQYWKXJWKIXHIlyw5lqr34tQgEOdcBsCOx5yZK3hCCKdYXneQkh4pEfqzLfu+wVDSyyzFoJjfz9NB+pAF+eizx2Vruts0k15mPgvS6GYvpVtQhB61IB/dk6AF6fS4Ben0uIX5odtFe8Q/eW1KvFeH4e8khT6+gm5B+t3juyDt7n0jpe+CANTd+oTUjN/U3yVaABnSUjFz/gFq44JaVSCXeQAAAABJRU5ErkJggg==);
                    }

                    /* Error icon encoded */
                    .IconErrorEncoded
                    {
                        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAABP0lEQVR4XqWTvUoDQRSFr4NBWRAD+gA+gMXmDWJlFbC3iCBY2Qm2YmttKyhYaaFtGiPY2CWFD2BjEwiugkv8XecbcmHmEgTJgUs2371ndmY4OyNGZVluedD21TStW19nWZadKrDGFV+915tONdhsVU/LkhSMHjPMqi/sYAx6b3s79Y/Lc/lLc9u7kh0cFR40/G4e3ZhflYf7wVxbzUNZKX8/ORZm8cAdZ/66v8tpYFy67lLJIpYziwev48JGHsRyi3UdVnNgsfDg5fzpZTXz6rt4rhC/0TO9ZBbvrBh9PvRluLGWvPXnpYCFnpWTKWUXiM/Mm6n4TiYGqKvBMefn/0SmwcLriOe8D4fKnlnvBBYLD15NIinMNUjIXFjMNY19n8RGEmUSRkj+HWUeAKy6cNGR2npLrGD0mFEzfOrP+Rf4+xT8EskwMAAAAABJRU5ErkJggg==);
                    }
                ]]>
            </xsl:text>
        </style>
        <script type="text/javascript" language="javascript">
          <xsl:text disable-output-escaping="yes">
          <![CDATA[
          
            // Startup 
            // Hook up the the loaded event for the document/window, to linkify the document content
            var startupFunction = function() { linkifyElement("messages"); };
            
            if(window.attachEvent)
            {
              window.attachEvent('onload', startupFunction);
            }
            else if (window.addEventListener) 
            {
              window.addEventListener('load', startupFunction, false);
            }
            else 
            {
              document.addEventListener('load', startupFunction, false);
            } 
            
            // Toggles the visibility of table rows with the specified name 
            function toggleTableRowsByName(name)
            {
               var allRows = document.getElementsByTagName('tr');
               for (i=0; i < allRows.length; i++)
               {
                  var currentName = allRows[i].getAttribute('name');
                  if(!!currentName && currentName.indexOf(name) == 0)
                  {
                      var isVisible = allRows[i].style.display == ''; 
                      isVisible ? allRows[i].style.display = 'none' : allRows[i].style.display = '';
                  }
               }
            }
            
            function scrollToFirstVisibleRow(name) 
            {
               var allRows = document.getElementsByTagName('tr');
               for (i=0; i < allRows.length; i++)
               {
                  var currentName = allRows[i].getAttribute('name');
                  var isVisible = allRows[i].style.display == ''; 
                  if(!!currentName && currentName.indexOf(name) == 0 && isVisible)
                  {
                     allRows[i].scrollIntoView(true); 
                     return true; 
                  }
               }
               
               return false;
            }
            
            // Linkifies the specified text content, replaces candidate links with html links 
            function linkify(text)
            {
                 if(!text || 0 === text.length)
                 {
                     return text; 
                 }

                 // Find http, https and ftp links and replace them with hyper links 
                 var urlLink = /(http|https|ftp)\:\/\/[a-zA-Z0-9\-\.]+(:[a-zA-Z0-9]*)?\/?([a-zA-Z0-9\-\._\?\,\/\\\+&%\$#\=~;\{\}])*/gi;
                 
                 return text.replace(urlLink, '<a href="$&">$&</a>') ;
            }
            
            // Linkifies the specified element by ID
            function linkifyElement(id)
            {
                var element = document.getElementById(id);
                if(!!element)
                {
                  element.innerHTML = linkify(element.innerHTML); 
                }
            }
            
            function ToggleMessageVisibility(projectName)
            {
              if(!projectName || 0 === projectName.length)
              {
                return; 
              }
              
              toggleTableRowsByName("MessageRowClass" + projectName);
              toggleTableRowsByName('MessageRowHeaderShow' + projectName);
              toggleTableRowsByName('MessageRowHeaderHide' + projectName); 
            }
            
            function ScrollToFirstVisibleMessage(projectName)
            {
              if(!projectName || 0 === projectName.length)
              {
                return; 
              }
              
              // First try the 'Show messages' row
              if(!scrollToFirstVisibleRow('MessageRowHeaderShow' + projectName))
              {
                // Failed to find a visible row for 'Show messages', try an actual message row 
                scrollToFirstVisibleRow('MessageRowClass' + projectName); 
              }
            }
          ]]>
        </xsl:text>
        </script>
      </head>
      <body>
        <h1 _locID="ConversionReport">
          Rapport de migration - <xsl:value-of select="Properties/Property[@Name='Solution']/@Value"/>
        </h1>

        <div id="content">
          <h2 _locID="OverviewTitle">Vue d'ensemble</h2>
          <xsl:variable name="projectOverview">
            <xsl:apply-templates select="self::node()" mode="ProjectOverviewXML"/>
          </xsl:variable>

          <div id="overview">
            <xsl:apply-templates select="msxsl:node-set($projectOverview)/*" mode="ProjectOverview"/>
          </div>

          <h2 _locID="SolutionAndProjectsTitle">Solution et projets</h2>

          <div id="messages">
            <xsl:apply-templates select="msxsl:node-set($projectOverview)/*" mode="ProjectDetails"/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
