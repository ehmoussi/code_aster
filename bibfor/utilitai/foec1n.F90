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

subroutine foec1n(iuni, nomf, vec, nbfonc, verif)
    implicit none
#include "asterfort/fopro1.h"
    integer :: iuni, nbfonc
    character(len=*) :: nomf, vec(*), verif
!     ECRITURE DE NIVEAU 1 (IMPR=1) D'UNE NAPPE: ATTRIBUTS
!     ------------------------------------------------------------------
!     ARGUMENTS D'ENTREE:
!        IUNI  : NUMERO D'UNITE LOGIQUE D'ECRITURE
!        NOMFON: NOM UTILISATEUR DE LA NAPPE
!        VEC   : VECTEUR DES ATTRIBUTS (NOMFON.PROL)
!        NBFONC: NOMBRE DE COUPLES DE (PARAMETRE, FONCTION)
!        VERIF : OPTION UTILISATEUR DE VERIFICATION DE CROISSANCE
!                DES VALEURS DU PARAMETRE
!     ------------------------------------------------------------------
    character(len=8) :: interp, prolgd, tprol(3)
    character(len=8) :: nompan, nomres, nompaf
    character(len=19) :: nomfon
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    data tprol/'CONSTANT','LINEAIRE','EXCLU'/
!
    nomfon = nomf
    nompaf = vec(7)
    nompan = vec(3)
    nomres = vec(4)
    write(iuni,*) ' NAPPE ',nomfon,' : ',&
     &                          nomres,' = F(',nompan,', ',nompaf,')'
    write(iuni,*) ' DONNEE EN ',nbfonc,' POINTS'
    call fopro1(vec, 0, prolgd, interp)
    write(iuni,*) ' INTERPOLATION ',interp
    do 1 i = 1, 3
        if (prolgd(1:1) .eq. tprol(i)(1:1)) then
            write(iuni,*) ' PROLONGEMENT A GAUCHE : ',tprol(i)
        endif
        if (prolgd(2:2) .eq. tprol(i)(1:1)) then
            write(iuni,*) ' PROLONGEMENT A DROITE : ',tprol(i)
        endif
 1  end do
    if (verif .eq. '        ') then
        write(iuni,*) ' LES PARAMETRES DE LA NAPPE SONT REORDONNES'
    else if (verif.eq.'CROISSANT') then
        write(iuni,*) ' VERIFICATION ',verif
    endif
end subroutine
