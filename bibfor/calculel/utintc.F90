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

subroutine utintc(zrino2, zrino1, zrjno2, zrjno1, x3,&
                  y3, inst, insold, k8cart, ltheta,&
                  nsomm, valfp, valfm, ifm, niv,&
                  option)
! person_in_charge: olivier.boiteau at edf.fr
!-----------------------------------------------------------------------
!    - FONCTION REALISEE:  UTILITAIRE D'INTERPOLATION 2D DE CHARGE
!                          POUR AERER TE0003
!
!   COORDONNEES POINTS D'INTERPOLATION
! IN ZRINO2/1 : ABSCISSE/ORDONNEE POINT DE DEPART DE L'ARETE INO
! IN ZRJNO2/1 : ABSCISSE/ORDONNEE POINT EXTREME DE L'ARETE JNO
! IN X3/Y3    : ABSCISSE/ORDONNEE POINT MILIEU DE L'ARETE MNO
! IN INST/INSOLD : INSTANT + / INSTANT -
! IN K8CART   : CHAMP JEVEUX A INTERPOLER
! IN LTHETA   : LOGICAL = TRUE SI THETA DIFFERENT DE 1
! IN NSOMM    : INDICATEUR DU NOMBRE DE SOMMETS PAR ARETE
! IN IFM/NIV/OPTION  : PARAMETRES D'AFFICHAGE
! OUT VALFP/M : VALEUR DU CHAMP RESULTAT AU INSTANTS +/- ET
!               AUX POINTS CI-DESSUS
!   -------------------------------------------------------------------
!     SUBROUTINES APPELLEES:
!       FOINTE.
!
!     FONCTIONS INTRINSEQUES:
!       AUCUNE.
!   -------------------------------------------------------------------
!     ASTER INFORMATIONS:
!       03/07/01 (OB): CREATION POUR SIMPLIFIER TE0003.F.
!----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
! DECLARATION PARAMETRES D'APPELS
#include "asterf_types.h"
#include "asterfort/fointe.h"
    integer :: nsomm, ifm, niv, option
    real(kind=8) :: zrino2, zrino1, zrjno2, zrjno1, x3, y3, inst, insold
    real(kind=8) :: valfp(9), valfm(9)
    character(len=8) :: k8cart
    aster_logical :: ltheta
!
! DECLARATION VARIABLES LOCALES
    integer :: icode
    real(kind=8) :: valpar(3)
    character(len=8) :: nompar(3)
!
! INIT
    nompar(1) = 'X'
    nompar(2) = 'Y'
    nompar(3) = 'INST'
!
! INTERPOLATION CHAMP K8CART A L'INSTANT +
    valpar(1) = zrino2
    valpar(2) = zrino1
    valpar(3) = inst
    call fointe('FM', k8cart, 3, nompar, valpar,&
                valfp(1), icode)
    valpar(1) = zrjno2
    valpar(2) = zrjno1
    call fointe('FM', k8cart, 3, nompar, valpar,&
                valfp(2), icode)
    if (nsomm .eq. 3) then
        valpar(1) = x3
        valpar(2) = y3
        call fointe('FM', k8cart, 3, nompar, valpar,&
                    valfp(3), icode)
    endif
    if (ltheta) then
!
! INTERPOLATION CHAMP K8CART A L'INSTANT -
        valpar(1) = zrino2
        valpar(2) = zrino1
        valpar(3) = insold
        call fointe('FM', k8cart, 3, nompar, valpar,&
                    valfm(1), icode)
        valpar(1) = zrjno2
        valpar(2) = zrjno1
        call fointe('FM', k8cart, 3, nompar, valpar,&
                    valfm(2), icode)
        if (nsomm .eq. 3) then
            valpar(1) = x3
            valpar(2) = y3
            call fointe('FM', k8cart, 3, nompar, valpar,&
                        valfm(3), icode)
        endif
    endif
!
! AFFICHAGES
    if (niv .eq. 2) then
        if (nsomm .eq. 3) then
            write(ifm,*)' X    ',zrino2,zrjno2,x3
            write(ifm,*)' Y    ',zrino1,zrjno1,y3
            if (option .eq. 1) then
                write(ifm,*)' VALFP ',valfp(1),valfp(2),valfp(3)
            else if (option.eq.2) then
                write(ifm,*)' VALHP ',valfp(1),valfp(2),valfp(3)
            else
                write(ifm,*)' VALTP ',valfp(1),valfp(2),valfp(3)
            endif
            if (ltheta) write(ifm,*)'     M ', valfm(1),valfm(2),valfm(3)
        else
            write(ifm,*)' X    ',zrino2,zrjno2
            write(ifm,*)' Y    ',zrino1,zrjno1
            if (option .eq. 1) then
                write(ifm,*)' VALFP ',valfp(1),valfp(2)
            else if (option.eq.2) then
                write(ifm,*)' VALHP ',valfp(1),valfp(2)
            else
                write(ifm,*)' VALTP ',valfp(1),valfp(2)
            endif
            if (ltheta) write(ifm,*)'     M ',valfm(1),valfm(2)
        endif
    endif
!
end subroutine
