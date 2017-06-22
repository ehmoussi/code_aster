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

subroutine rkcah1(rela_comp, y, pas, nvi, w,&
                  wk, h, eps, iret)
implicit none
!
!
!     INTEGRATION DE LOIS DE COMPORTEMENT PAR  RUNGE KUTTA
!     CALCUL DU NOUVEAU PAS DE TEMPS (AUGMENTATION)
!      IN RELA_COMP    :  NOM DU MODELE DE COMPORTEMENT
!         Y       :  VARIABLES INTERNES
!         PAS     :  INTERVALLE DE TEMPS TF-TD
!     OUT H       :  PAS DE TEMPS
!
    integer :: ne, ny, na, nvi, ii, iret
    character(len=16) :: rela_comp
    real(kind=8) :: pas, h, w, dmg0, eps, maxout, maxdom, wk(*), y(*)
    parameter  ( maxdom = 9.90d-01  )
!
    ne=0
    ny=nvi
    na=ny+nvi
    iret=0
!
    maxout=maxdom-eps
!
    if (rela_comp(1:9) .eq. 'VENDOCHAB') then
!        TRAITEMENT VENDOCHAB
!        TEST SUR LE NIVEAU DE DOMMAGE--
        if (y(9) .ge. maxdom) then
            dmg0=(y(9)-wk(9))-(wk(na+9)*h)
            if (dmg0 .ge. maxout) then
                do ii = 1, nvi
                    y(ii)=(y(ii)-wk(ne+ii))-(wk(na+ii)*h)
                end do
                iret=1
            else
                h=(maxout-dmg0)/((wk(ne+9)/h)+wk(na+9))
                if (h .gt. pas) h=pas
            endif
        else
!           FIN TEST SUR LE NIVEAU DE DOMMAGE
            w=w/abs(eps)
            w=max(w,1.0d-05)
            h=h*w**(-2.0d-01)*9.0d-01
            if (h .gt. pas) h=pas
        endif
!        FIN TRAITEMENT VENDOCHAB
!
    else
!        IP.NE.1
!        CALCUL CLASSIQUE DU NOUVEAU PAS DE TEMPS (ISSU DE RK4)
        w=w/abs(eps)
        w=max(w,1.0d-05)
!        POUR 1.0D-05, COEF=9.
        h=h*w**(-2.0d-01)*9.0d-01
        if (h .gt. pas) h=pas
!
    endif
!
end subroutine
