Public Class Form1
    Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)


    Private Sub connexion_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles connexion.Click

        socket.Connect()

    End Sub

    Private Sub socket_DataArrival(ByVal sender As Object, ByVal e As Winsock_Orcas.WinsockDataArrivalEventArgs) Handles socket.DataArrival
        Dim reponse(20) As Byte

        reponse = socket.Get
        valeur_entrees.Text = reponse(9)

        If (clone.Checked = True) Then
            Dim cloner_entrees() As Byte = {0, 0, 0, 0, 0, 9, 1, 15, 0, 0, 0, 4, 2, reponse(9), 0}
            socket.Send(cloner_entrees)
            clone.Checked = False
        End If

    End Sub

    Private Sub Winsock1_StateChanged(ByVal sender As Object, ByVal e As Winsock_Orcas.WinsockStateChangedEventArgs) Handles socket.StateChanged

        etat_socket.Text = e.New_State.ToString

    End Sub

    Private Sub sortir_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles sortir.Click

        Me.Close()

    End Sub

    Private Sub etat_socket_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles etat_socket.TextChanged

        If etat_socket.Text = "Connected" Then
            etat_socket.BackColor = Color.Green
            connexion.Enabled = False
            lecture.Enabled = True
            deconnexion.Enabled = True
            ecriture_sorties.Enabled = True
            sortie_4.Enabled = True
            sortie_3.Enabled = True
            sortie_2.Enabled = True
            sortie_1.Enabled = True
            chenillard.Enabled = True
            clone.Enabled = True
        ElseIf etat_socket.Text = "Closed" Then
            etat_socket.BackColor = Color.Silver
            connexion.Enabled = True
            lecture.Enabled = False
            deconnexion.Enabled = False
            ecriture_sorties.Enabled = False
            sortie_4.Checked = False
            sortie_3.Checked = False
            sortie_2.Checked = False
            sortie_1.Checked = False
            sortie_4.Enabled = False
            sortie_3.Enabled = False
            sortie_2.Enabled = False
            sortie_1.Enabled = False
            label_entree.Enabled = False
            label_sortie.Enabled = False
            chenillard.Enabled = False
            clone.Checked = False
            clone.Enabled = False
            valeur_entrees.Text = ""
        ElseIf etat_socket.Text = "Connecting" Then
            etat_socket.BackColor = Color.Red
        End If

    End Sub
    Private Sub lecture_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lecture.Click

        Dim commande() As Byte = {0, 0, 0, 0, 0, 6, 1, 2, 0, 0, 0, 4}

        label_sortie.Enabled = False
        label_entree.Enabled = True

        socket.Send(commande)

    End Sub

    Private Sub deconnexion_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles deconnexion.Click

        socket.Close()

    End Sub

    Private Sub ecriture_sorties_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ecriture_sorties.Click
        Dim etat_sortie_1 As Byte
        Dim etat_sortie_2 As Byte
        Dim etat_sortie_3 As Byte
        Dim etat_sortie_4 As Byte

        Dim valeur As Byte = 0

        If (sortie_4.Checked) = True Then
            etat_sortie_1 = 1
        Else
            etat_sortie_1 = 0
        End If

        If (sortie_3.Checked) = True Then
            etat_sortie_2 = 1
        Else
            etat_sortie_2 = 0
        End If

        If (sortie_2.Checked) = True Then
            etat_sortie_3 = 1
        Else
            etat_sortie_3 = 0
        End If

        If (sortie_1.Checked) = True Then
            etat_sortie_4 = 1
        Else
            etat_sortie_4 = 0
        End If

        valeur = (1 * etat_sortie_1) + (2 * etat_sortie_2) + (4 * etat_sortie_3) + (8 * etat_sortie_4)
        Dim commande() As Byte = {0, 0, 0, 0, 0, 9, 1, 15, 0, 0, 0, 4, 2, valeur, 0}

        label_sortie.Enabled = True
        label_entree.Enabled = False

        socket.Send(commande)

    End Sub

    Private Sub chenillard_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chenillard.Click
        label_sortie.Enabled = False
        label_entree.Enabled = False

        For i As Byte = 0 To 15
            Dim chenillard() As Byte = {0, 0, 0, 0, 0, 9, 1, 15, 0, 0, 0, 4, 2, i, 0}
            socket.Send(chenillard)
            Sleep(1000)
        Next

        Dim commande() As Byte = {0, 0, 0, 0, 0, 9, 1, 15, 0, 0, 0, 4, 2, 0, 0}
        socket.Send(commande)

    End Sub
End Class
