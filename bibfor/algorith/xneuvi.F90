! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine xneuvi(nb_edgez, nb_edge, nbno, tabdir, scorno,&
                  noeud, crack, tabhyp)
!
! aslint: disable=W1306
    implicit none
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    integer :: nb_edgez, nb_edge, nbno
    integer :: tabdir(nb_edgez, 2), scorno(2*nb_edgez), noeud(2*nb_edgez)
    character(len=8) :: crack
    aster_logical, intent(in) :: tabhyp(nb_edgez)
!
! ROUTINE XFEM
!
! SERT A CREER POUR UNE FISSURE DONNEE, LES GROUPES D'ARETES VITALES
!      CONNECTEES A UN NOEUD
!
! FISS.CONNECTANT :
!      CHAQUE NOEUD RELIÉ A PLUS D'UNE ARETE VITALE (SCORE(NOEUD) > 1)
!      EST STOQUÉ ICI ET DEFINI UN GROUPE D'ARETES
! FISS.CONNECTES :
!      POUR CHAQUE NOEUD CONNECTANT, ON STOQUE ICI LES NOEUDS RELIÉS
!      QUI FORMENT LES ARETES VITALE
!
! TRAVAIL EFFECTUE EN COLLABORATION AVEC L'I.F.P.
!
! ----------------------------------------------------------------------
!
! IN  nb_edgez   : NOMBRE D'ARETES COUPEES
! IN  NAR    : NBRE D'ARETES COUPEES NON HYPERSTATIQUES (NH DANS XRELL2)
! IN  NBNO   : NOMBRE DE NOEUDS APARTENANTS AU MOINS A UNE ARETE COUPEE
! IN  TABDIR : TABLEAU DES NOEUDS DES ARETES NH
! IN  SCORNO : REDONE LE SCORE DES NOEUDS DES ARETES
! IN  NOEUD  : REDONE LE NUMERO GLOBAL DES NOEUDS DES ARETES
! IN  CRACK  : NOM DE LA FISSURE
! IN  TABHYP : TABLEAU DES ARETES HYPERSTATIQUES, QUI NE SERONT PAS STOCKEES
!              DANS CONNECTANT / CONNECTES
!
!
!
!
    integer :: nnovit, nncone, novit(nbno)
    integer :: i, k, ia
    integer :: jcntan, jcntes
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nnovit = 0
    nncone = 0
!
! --- ON COMPTE ET ON SELECTIONNE LES NOEUDS CONECTANTS
    do i = 1, nbno
        if (scorno(i) .gt. 1) then
            nnovit = nnovit + 1
            novit(nnovit) = i
        endif
    end do
!
! --- ON CONSTRUIT LE VECTEUR DES NOEUDS CONNECTANTS
    if (nnovit .ne. 0) then
        call wkvect(crack(1:8)//'.CONNECTANT', 'G V I', 3*nnovit, jcntan)
        do i = 1, nnovit
! --- POUR CHAQUE NOEUD VITAL, ON STOQUE SON NUMERO, LE NOMBRE DE NOEUDS
! --- QU'IL CONNECTE ET LEPOINTEUR SUR LES NOEUDS QU'IL CONECTE
            zi(jcntan-1+3*(i-1)+1) = noeud(novit(i))
            zi(jcntan-1+3*(i-1)+2) = scorno(novit(i))
            zi(jcntan-1+3*(i-1)+3) = nncone
            nncone = nncone + scorno(novit(i))
        end do
! --- ON CONSTRUIT LE VECTEUR DES NOEUDS CONNECTÉS
        call wkvect(crack(1:8)//'.CONNECTES ', 'G V I', nncone, jcntes)
        k=0
        do i = 1, nnovit
! --- POUR CHAQUE NOEUD VITAL, ON STOQUE SES NOEUDS CONECTÉS
            do ia = 1, nb_edge
                if(tabhyp(ia)) cycle
                if (tabdir(ia,1) .eq. novit(i)) then
                    k = k+1
                    zi(jcntes-1+k) = noeud(tabdir(ia,2))
                else if (tabdir(ia,2).eq.novit(i)) then
                    k = k+1
                    zi(jcntes-1+k) = noeud(tabdir(ia,1))
                endif
            end do
        end do
    endif
!
    call jedema()
!
end subroutine
