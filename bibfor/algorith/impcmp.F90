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

subroutine impcmp(icmp, numedd, chaine)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/rgndas.h"
    integer :: icmp
    character(len=24) :: numedd
    character(len=16) :: chaine
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (AFFICHAGE - UTILITAIRE)
!
! RETOURNE UNE CHAINE FORMATEE K16 POUR LES INFOS SUR UNE COMPOSANTE
!
! ----------------------------------------------------------------------
!
!
! IN  ICMP   : NUMERO DE L'EQUATION
! IN  NUMEDD : NUMEROTATION NUME_DDL
! OUT CHAINE : CHAINE DU NOM DU NOEUD OU 'LIAISON_DDL'
!              CHAINE DU NOM DE LA CMP OU NOM DU LIGREL DE CHARGE
!
!
!
!
    character(len=8) :: nomno, nomcmp, load
    character(len=1) :: tyddl
!
! ----------------------------------------------------------------------
!
    chaine = ' '
!
    if (icmp .ne. 0) then
        call rgndas(numedd, icmp, l_print = .false., type_equaz = tyddl, name_nodez = nomno,&
                    name_cmpz = nomcmp, ligrelz = load)
        if (tyddl .eq. 'A') then
            chaine(1:8)  = nomno
            chaine(9:16) = nomcmp
        elseif (tyddl .eq. 'B') then
            chaine(1:16) = 'Link : '//nomno
        elseif (tyddl .eq. 'C') then
            chaine(1:16) = 'Link : '//load
        endif
    endif
!
end subroutine
