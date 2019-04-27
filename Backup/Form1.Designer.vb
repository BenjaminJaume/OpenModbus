<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.connexion = New System.Windows.Forms.Button
        Me.lecture = New System.Windows.Forms.Button
        Me.label_entree = New System.Windows.Forms.Label
        Me.valeur_entrees = New System.Windows.Forms.TextBox
        Me.socket = New Winsock_Orcas.Winsock
        Me.label1 = New System.Windows.Forms.Label
        Me.etat_socket = New System.Windows.Forms.TextBox
        Me.deconnexion = New System.Windows.Forms.Button
        Me.sortir = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.ecriture_sorties = New System.Windows.Forms.Button
        Me.sortie_4 = New System.Windows.Forms.CheckBox
        Me.sortie_3 = New System.Windows.Forms.CheckBox
        Me.sortie_2 = New System.Windows.Forms.CheckBox
        Me.sortie_1 = New System.Windows.Forms.CheckBox
        Me.label_sortie = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.chenillard = New System.Windows.Forms.Button
        Me.clone = New System.Windows.Forms.CheckBox
        Me.SuspendLayout()
        '
        'connexion
        '
        Me.connexion.Location = New System.Drawing.Point(70, 12)
        Me.connexion.Name = "connexion"
        Me.connexion.Size = New System.Drawing.Size(126, 23)
        Me.connexion.TabIndex = 0
        Me.connexion.Text = "Connexion"
        Me.connexion.UseVisualStyleBackColor = True
        '
        'lecture
        '
        Me.lecture.Enabled = False
        Me.lecture.Location = New System.Drawing.Point(70, 53)
        Me.lecture.Name = "lecture"
        Me.lecture.Size = New System.Drawing.Size(126, 23)
        Me.lecture.TabIndex = 1
        Me.lecture.Text = "Lire les entrées"
        Me.lecture.UseVisualStyleBackColor = True
        '
        'label_entree
        '
        Me.label_entree.AutoSize = True
        Me.label_entree.Enabled = False
        Me.label_entree.Location = New System.Drawing.Point(73, 93)
        Me.label_entree.Name = "label_entree"
        Me.label_entree.Size = New System.Drawing.Size(49, 13)
        Me.label_entree.TabIndex = 2
        Me.label_entree.Text = "Entrées :"
        '
        'valeur_entrees
        '
        Me.valeur_entrees.Location = New System.Drawing.Point(70, 122)
        Me.valeur_entrees.Name = "valeur_entrees"
        Me.valeur_entrees.ReadOnly = True
        Me.valeur_entrees.Size = New System.Drawing.Size(126, 20)
        Me.valeur_entrees.TabIndex = 3
        Me.valeur_entrees.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'socket
        '
        Me.socket.BufferSize = 8192
        Me.socket.LegacySupport = True
        Me.socket.LocalPort = 8080
        Me.socket.MaxPendingConnections = 1
        Me.socket.Protocol = Winsock_Orcas.WinsockProtocol.Tcp
        Me.socket.RemoteHost = "192.168.0.80"
        Me.socket.RemotePort = 502
        '
        'label1
        '
        Me.label1.AutoSize = True
        Me.label1.Location = New System.Drawing.Point(88, 259)
        Me.label1.Name = "label1"
        Me.label1.Size = New System.Drawing.Size(93, 13)
        Me.label1.TabIndex = 4
        Me.label1.Text = "Etat de la socket :"
        '
        'etat_socket
        '
        Me.etat_socket.ForeColor = System.Drawing.SystemColors.WindowText
        Me.etat_socket.Location = New System.Drawing.Point(70, 285)
        Me.etat_socket.Name = "etat_socket"
        Me.etat_socket.ReadOnly = True
        Me.etat_socket.Size = New System.Drawing.Size(126, 20)
        Me.etat_socket.TabIndex = 5
        Me.etat_socket.TextAlign = System.Windows.Forms.HorizontalAlignment.Center
        '
        'deconnexion
        '
        Me.deconnexion.Enabled = False
        Me.deconnexion.Location = New System.Drawing.Point(70, 418)
        Me.deconnexion.Name = "deconnexion"
        Me.deconnexion.Size = New System.Drawing.Size(126, 23)
        Me.deconnexion.TabIndex = 6
        Me.deconnexion.Text = "Deconnexion"
        Me.deconnexion.UseVisualStyleBackColor = True
        '
        'sortir
        '
        Me.sortir.Location = New System.Drawing.Point(70, 460)
        Me.sortir.Name = "sortir"
        Me.sortir.Size = New System.Drawing.Size(126, 23)
        Me.sortir.TabIndex = 7
        Me.sortir.Text = "Sortir"
        Me.sortir.UseVisualStyleBackColor = True
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(107, 198)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(45, 13)
        Me.Label2.TabIndex = 8
        Me.Label2.Text = "Sorties :"
        '
        'ecriture_sorties
        '
        Me.ecriture_sorties.Enabled = False
        Me.ecriture_sorties.Location = New System.Drawing.Point(70, 160)
        Me.ecriture_sorties.Name = "ecriture_sorties"
        Me.ecriture_sorties.Size = New System.Drawing.Size(126, 23)
        Me.ecriture_sorties.TabIndex = 9
        Me.ecriture_sorties.Text = "Ecrire sur les sorties"
        Me.ecriture_sorties.UseVisualStyleBackColor = True
        '
        'sortie_4
        '
        Me.sortie_4.AutoSize = True
        Me.sortie_4.Enabled = False
        Me.sortie_4.Location = New System.Drawing.Point(70, 225)
        Me.sortie_4.Name = "sortie_4"
        Me.sortie_4.Size = New System.Drawing.Size(15, 14)
        Me.sortie_4.TabIndex = 10
        Me.sortie_4.UseVisualStyleBackColor = True
        '
        'sortie_3
        '
        Me.sortie_3.AutoSize = True
        Me.sortie_3.Enabled = False
        Me.sortie_3.Location = New System.Drawing.Point(107, 225)
        Me.sortie_3.Name = "sortie_3"
        Me.sortie_3.Size = New System.Drawing.Size(15, 14)
        Me.sortie_3.TabIndex = 11
        Me.sortie_3.UseVisualStyleBackColor = True
        '
        'sortie_2
        '
        Me.sortie_2.AutoSize = True
        Me.sortie_2.Enabled = False
        Me.sortie_2.Location = New System.Drawing.Point(146, 225)
        Me.sortie_2.Name = "sortie_2"
        Me.sortie_2.Size = New System.Drawing.Size(15, 14)
        Me.sortie_2.TabIndex = 12
        Me.sortie_2.UseVisualStyleBackColor = True
        '
        'sortie_1
        '
        Me.sortie_1.AutoSize = True
        Me.sortie_1.Enabled = False
        Me.sortie_1.Location = New System.Drawing.Point(181, 225)
        Me.sortie_1.Name = "sortie_1"
        Me.sortie_1.Size = New System.Drawing.Size(15, 14)
        Me.sortie_1.TabIndex = 13
        Me.sortie_1.UseVisualStyleBackColor = True
        '
        'label_sortie
        '
        Me.label_sortie.AutoSize = True
        Me.label_sortie.Enabled = False
        Me.label_sortie.Location = New System.Drawing.Point(156, 93)
        Me.label_sortie.Name = "label_sortie"
        Me.label_sortie.Size = New System.Drawing.Size(40, 13)
        Me.label_sortie.TabIndex = 14
        Me.label_sortie.Text = "Sortie :"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(129, 92)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(12, 13)
        Me.Label3.TabIndex = 15
        Me.Label3.Text = "/"
        '
        'chenillard
        '
        Me.chenillard.Enabled = False
        Me.chenillard.Location = New System.Drawing.Point(70, 333)
        Me.chenillard.Name = "chenillard"
        Me.chenillard.Size = New System.Drawing.Size(126, 23)
        Me.chenillard.TabIndex = 16
        Me.chenillard.Text = "Chenillard"
        Me.chenillard.UseVisualStyleBackColor = True
        '
        'clone
        '
        Me.clone.AutoSize = True
        Me.clone.Enabled = False
        Me.clone.Location = New System.Drawing.Point(51, 379)
        Me.clone.Name = "clone"
        Me.clone.Size = New System.Drawing.Size(176, 17)
        Me.clone.TabIndex = 17
        Me.clone.Text = "Cloner les entrées sur les sorties"
        Me.clone.UseVisualStyleBackColor = True
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(261, 508)
        Me.Controls.Add(Me.clone)
        Me.Controls.Add(Me.chenillard)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.label_sortie)
        Me.Controls.Add(Me.sortie_1)
        Me.Controls.Add(Me.sortie_2)
        Me.Controls.Add(Me.sortie_3)
        Me.Controls.Add(Me.sortie_4)
        Me.Controls.Add(Me.ecriture_sorties)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.sortir)
        Me.Controls.Add(Me.deconnexion)
        Me.Controls.Add(Me.etat_socket)
        Me.Controls.Add(Me.label1)
        Me.Controls.Add(Me.valeur_entrees)
        Me.Controls.Add(Me.label_entree)
        Me.Controls.Add(Me.lecture)
        Me.Controls.Add(Me.connexion)
        Me.Name = "Form1"
        Me.Text = "Lecture d'entrées / sorties"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents connexion As System.Windows.Forms.Button
    Friend WithEvents lecture As System.Windows.Forms.Button
    Friend WithEvents label_entree As System.Windows.Forms.Label
    Friend WithEvents valeur_entrees As System.Windows.Forms.TextBox
    Friend WithEvents socket As Winsock_Orcas.Winsock
    Friend WithEvents label1 As System.Windows.Forms.Label
    Friend WithEvents etat_socket As System.Windows.Forms.TextBox
    Friend WithEvents deconnexion As System.Windows.Forms.Button
    Friend WithEvents sortir As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents ecriture_sorties As System.Windows.Forms.Button
    Friend WithEvents sortie_4 As System.Windows.Forms.CheckBox
    Friend WithEvents sortie_3 As System.Windows.Forms.CheckBox
    Friend WithEvents sortie_2 As System.Windows.Forms.CheckBox
    Friend WithEvents sortie_1 As System.Windows.Forms.CheckBox
    Friend WithEvents label_sortie As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents chenillard As System.Windows.Forms.Button
    Friend WithEvents clone As System.Windows.Forms.CheckBox

End Class
