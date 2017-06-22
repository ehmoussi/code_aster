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

subroutine impcom(inoda, nomddl, chaine)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    character(len=8) :: nomddl
    integer :: inoda
    character(len=16) :: chaine
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (AFFICHAGE - UTILITAIRE)
!
! RETOURNE UNE CHAINE FORMATEE K16 POUR LES INFOS SUR UNE COMPOSANTE
! POUR LE CAS D UN RESIDU RESI_COMP_RELA
!
! ----------------------------------------------------------------------
!
!
! IN  INODA  : NUMERO DU NOEUD
! IN  NOMDDL : CHAINE DU COMPOSANT
! OUT CHAINE : CHAINE DU NOM DU NOEUD OU 'LIAISON_DDL'
!              CHAINE DU NOM DE LA CMP OU NOM DU LIGREL DE CHARGE
!
!
! ----------------------------------------------------------------------
!
    character(len=8) :: chnod
    integer :: i, k
    integer :: nchain
    parameter    (nchain = 7)
!
! ----------------------------------------------------------------------
!
    chaine = ' '
    chnod = '  '
    if (inoda .eq. 0) goto 99
!
    write(chnod(1:nchain),'(I7.7)') inoda
    k = 1
!
    do 10 i = 1, nchain
        if (chnod(i:i) .eq. '0') then
            k=k+1
        else
            chaine(1:1) = 'N'
            goto 20
        endif
10  end do
20  continue
!
    chaine(2:nchain-k+2) = chnod(k:nchain)
!
    chaine(9:16) = nomddl
99  continue
end subroutine
