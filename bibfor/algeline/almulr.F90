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

subroutine almulr(czero, table, nbval, mantis, expo)
    implicit none
    character(len=*) :: czero
    integer :: nbval, expo
    real(kind=8) :: table(nbval), mantis
!     PRODUIT DE N NOMBRE AVEC TEST DE L OVERFLOW ET DE L'UNDERFLOW
!     AVEC CUMUL DE VALEUR ANTERIEUR OU REMISE A ZERO.
!     ------------------------------------------------------------------
! IN  CZERO  : K4  : DEMANDE DE REMISE A ZERO 'ZERO' OU DE CUMUL
! IN  TABLE  : R8  : TABLEAU DES VALEURS A MULTIPLIER
! IN  NBVAL  : R8  : NOMBRE DE VALEURS A MULTIPLIER
! VAR MANTIS : R8  : MANTISSE DU RESULTAT
! VAR EXPO   : IS  : EXPOSANT DU RESULTAT
!     ------------------------------------------------------------------
!     LE RESULTAT DU PRODUIT EST    MANTISS * 10 ** EXPO
!     UN "BON FORMAT" D'IMPRESSION EST
!         WRITE(?,'(10X,A,F16.10,A,I8)') 'PRODUIT = ',MANTIS,' E',EXPO
!     ------------------------------------------------------------------
!
    real(kind=8) :: trent, trent1, zero, dix
    integer :: itrent
!
!-----------------------------------------------------------------------
    integer :: ie, ival
!-----------------------------------------------------------------------
    trent = 1.d30
    itrent = 30
    trent1 = 1.d-30
    zero = 0.d0
    dix = 10.d0
!
    if (czero .eq. 'ZERO') then
        mantis = 1.d0
        expo = 0
    endif
!
    do 10 ival = 1, nbval
        mantis = mantis*table(ival)
        if (abs(mantis) .ge. trent) then
            mantis = mantis*trent1
            expo = expo + itrent
        else if (abs(mantis).le.trent1) then
            mantis = mantis*trent
            expo = expo - itrent
        endif
10  end do
!
    if (mantis .ne. zero) then
        ie = nint(log10(abs(mantis)))
        mantis = mantis/ (dix**ie)
        expo = expo + ie
    endif
!
end subroutine
