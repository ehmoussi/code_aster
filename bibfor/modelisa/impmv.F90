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

subroutine impmv(ifm, txt, mv, nn, isym)
!
!
! --------------------------------------------------------------------------------------------------
!
!       Impression d'une matrice stockée en colonne
!
!           mv    =  matrice stockée colonne
!           nn    =  longeur du vecteur de la matrice
!           txt   =  texte à afficher
!           ifm   =  unité d'impression
!           isym  =  (1) matrice symétrique
!                    (2) matrice non-symétrique
!
! --------------------------------------------------------------------------------------------------
!
    implicit   none
    integer :: ifm, nn, isym
    real(kind=8) :: mv(nn)
    character(len=8) :: txt
! --------------------------------------------------------------------------------------------------
    integer :: ii, jj, kk, dimmp
    real(kind=8) :: mp(12, 12)
! --------------------------------------------------------------------------------------------------
!
    if (nn .eq. 0) goto 999
!
    if (nn .eq. 4) dimmp = 2
    if (nn .eq. 9) dimmp = 3
    if (nn .eq. 16) dimmp = 4
    if (nn .eq. 36) dimmp = 6
    if (nn .eq. 144) dimmp = 12
!
    if (isym .eq. 1) then
!       Symétrique par colonne
        kk = 0
        do jj = 1, dimmp
            do  ii = 1, jj
                kk = kk + 1
                mp(ii,jj) = mv(kk)
                mp(jj,ii) = mv(kk)
            enddo
        enddo
        write(ifm,100) txt,'SYMETRIQUE'
    else
!      Non-symétrique par colonne
        kk = 0
        do jj = 1, dimmp
            do ii = 1, dimmp
                kk = kk + 1
                mp(ii,jj) = mv(kk)
            enddo
        enddo
        write(ifm,100) txt,'NON SYMETRIQUE'
    endif
!
    do ii = 1, dimmp
        write(ifm,201) (mp(ii,jj),jj=1,dimmp)
    enddo
!
100 format(3x,a8,3x,a20)
201 format(12(2x,1pd10.3))
!
999  continue
end subroutine
