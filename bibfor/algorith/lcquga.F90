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

subroutine lcquga(mode, eps, gameps, dgamde, itemax, precvg, iret)
    implicit none
    integer,intent(in)      :: mode, itemax
    real(kind=8),intent(in) :: eps(6), precvg
    real(kind=8),intent(out):: gameps, dgamde(6)
    integer, intent(out)    :: iret
! --------------------------------------------------------------------------------------------------
!  CALCUL DE GAMMA(EPS) POUR LA LOI ENDO_SCALAIRE AVEC GRAD_VARI
! --------------------------------------------------------------------------------------------------
!  IN  MODE    FONCTION RECHERCHEE (0=VALEUR, 1=VAL ET DER)
!  IN  EPS     VALEUR DE L'ARGUMENT EPS(1:NDIMSI)
!  OUT GAMEPS  FONCTION GAMMA(EPS) - SI MODE=1 OU MODE=0
!  OUT DGAMDE  DERIVEE DE GAMMA    - SI MODE=1
!  IN  ITEMAX  INUTILISE
!  IN  PRECVG  INUTILISE
!  OUT IRET    SYSTEMATIQUEMENT A ZERO
! --------------------------------------------------------------------------------------------------
    real(kind=8),parameter,dimension(6):: kr=(/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: epseq2, ueps, heps, coefh, coefs, treps, epsdv(6)
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: pct, pch, pcs
    common /lcmqu/ pch,pct,pcs
! --------------------------------------------------------------------------------------------------
!
!  INITIALISATION
!
    iret = 0
!
!
!  CALCUL DE LA VALEUR
!
    treps = eps(1)+eps(2)+eps(3)
    epsdv = eps - treps/3*kr
    epseq2 = 1.5d0*dot_product(epsdv,epsdv)
    ueps = pch*treps**2+pcs*epseq2
    heps = pct*treps+sqrt(ueps)
    gameps = heps*heps
!
!
!  CALCUL DE LA DERIVEE
!
    if (mode .eq. 1) then
        if (ueps .ne. 0) then
            coefh = pct + pch*treps/sqrt(ueps)
            coefs = 1.5d0*pcs/sqrt(ueps)
            dgamde = 2*heps*(coefh*kr+coefs*epsdv)
        else
            dgamde = 0
        endif
    endif
!
!
end subroutine
