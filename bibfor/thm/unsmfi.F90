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
!
subroutine unsmfi(j_mater, phi, temp, tbiot, aniso, cs)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/rcvala.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/THM_type.h"
!
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: phi
real(kind=8), intent(in) :: temp
real(kind=8), intent(in) :: tbiot(6)
integer, intent(in) :: aniso
real(kind=8), intent(out):: cs
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute Biot module
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
! In  phi          : current porosity
! In  tbiot        : tensor of Biot
! In  temp         : current temperature
! Out cs           : Biot module
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nelas3=3
    real(kind=8) :: val1(nelas3)
    real(kind=8) :: s(6, 6)
    real(kind=8) :: young1, young3, nu12, nu21, nu13, nu31, nu32, nu23, g13
    real(kind=8) :: youngs, biot1, biot3, delta, young2, g12, m33
    real(kind=8) :: k0
    character(len=8), parameter :: ncra3(nelas3) = (/'BIOT_L','BIOT_N','BIOT_T'/)
    integer :: icodr3(nelas3)
    integer :: i, j
    real(kind=8), parameter :: kron(6)  = (/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
    real(kind=8) :: skron(6)
    real(kind=8) :: nus
    real(kind=8) :: m11, m12, m13, ks
    real(kind=8), parameter :: eps = 1.d-21
!
! --------------------------------------------------------------------------------------------------
!
    skron(:) = 0.d0
    cs       = 0.d0
!
    if (aniso .eq. BIOT_TYPE_ISOT) then
        youngs = ds_thm%ds_material%e
        nus    = ds_thm%ds_material%nu
        k0     = youngs / 3.d0 / (1.d0-2.d0*nus)
        cs     = (tbiot(1)-phi)*(1.0d0-tbiot(1)) / k0
    else 
        if (aniso .eq. BIOT_TYPE_ISTR) then
            young1 = ds_thm%ds_material%e_l
            young3 = ds_thm%ds_material%e_n
            nu12   = ds_thm%ds_material%nu_lt
            nu13   = ds_thm%ds_material%nu_ln
            g13    = ds_thm%ds_material%g_ln
            nu31   = nu13*young3/young1
            call rcvala(j_mater, ' ', 'THM_DIFFU', 0, ' ',&
                        [temp], 2, ncra3(1), val1(1), icodr3,&
                        0)
            biot1 = val1(1)
            biot3 = val1(2)
            nus = 0.3d0
            m11 = young1*(young3-young1*nu13*nu13)/((1.d0+nu12)*&
                    (young3-young3*nu12-2.d0*young1*nu13*nu13))
            m12 = young1*(young3*nu12*(1.+nu13)+young1*nu13*nu13)/((1.d0+nu12)*&
                    (young3-young3*nu12-2.d0*young1*nu13*nu13))
            m13 = young1*young3*nu13/(young3-young3*nu12-2.d0* young1*nu13*nu13)
!
            if (abs(1.d0-biot1) .gt. eps) then
                ks = (m11+m12+m13)/(3.d0*(1.d0-biot1))
            else if (abs(1.d0-biot3).gt.eps) then
                m33 = young1*young1*(1.d0-nu12)/ (young3-young3*nu12-2.d0* young1*nu13*nu13)
                ks  = (2*m13+m33)/(3.d0*(1.d0-biot3))
            else
! MATERIAU INCOMPRESSIBLE
                cs = 0.d0
                goto 999
            endif
        else if (aniso .eq. BIOT_TYPE_ORTH) then
            young1 = ds_thm%ds_material%e_l
            young3 = ds_thm%ds_material%e_n
            young2 = ds_thm%ds_material%e_t
            nu12   = ds_thm%ds_material%nu_lt
            nu13   = ds_thm%ds_material%nu_ln
            nu23   = ds_thm%ds_material%nu_tn
            g12    = ds_thm%ds_material%g_lt

            call rcvala(j_mater, ' ', 'THM_DIFFU', 0, ' ',&
                        [temp], 3, ncra3(1), val1(1), icodr3,&
                        0)
            biot1 = val1(1)
            biot3 = val1(2)
!
            nus = 0.3d0
            nu21 = nu12*young2/young1
            nu31 = nu13*young3/young1
            nu32 = nu23*young3/young2
            delta = 1.d0-nu23*nu32-nu31*nu13-nu21*nu12-2.d0*nu23*nu31*nu12
!
            m11=(1.d0 - nu23*nu32)*young1/delta
            m12=(nu21 + nu31*nu23)*young1/delta
            m13=(nu31 + nu21*nu32)*young1/delta
!
            if (abs(1.d0-biot1) .gt. eps) then
                ks=(m11+m12+m13)/(3.d0*(1.d0-biot1))
            else if (abs(1.d0-biot3).gt.eps) then
                m33=young1*young1*(1.d0-nu12)/ (young3-young3*nu12-2.d0* young1*nu31*nu31)
                ks=(2*m13+m33)/(3.d0*(1.d0-biot3))
            else
! MATERIAU INCOMPRESSIBLE
                cs = 0.d0
                goto 999
            endif
        else
            ASSERT(.false.)
        endif
!
        youngs=ks*(3.d0*(1.d0-2.d0*nus))
!
! CALCUL DE LA MATRICE DE SOUPLESSE DE LA MATRICE SOLIDE
!
        do i = 1, 6
            do j = 1, 6
                s(i,j)=0.d0
            end do
        end do
!
        s(1,1)=1.d0/youngs
        s(2,2)=1.d0/youngs
        s(3,3)=1.d0/youngs
        s(1,2)=-nus/youngs
        s(1,3)=-nus/youngs
        s(2,1)=-nus/youngs
        s(2,3)=-nus/youngs
        s(3,1)=-nus/youngs
        s(3,2)=-nus/youngs
        s(4,4)=2.d0*(1.d0+nus)/youngs
        s(5,5)=2.d0*(1.d0+nus)/youngs
        s(6,6)=2.d0*(1.d0+nus)/youngs
!
! CALCUL DU MODULE DE BIOT DANS LE CAS ISOTROPE TRANSVERSE
!
        cs=0.d0
        do i = 1, 6
            do j = 1, 6
                skron(i)=skron(i)+s(i,j)*kron(j)
            end do
        end do
        do i = 1, 6
            cs=cs+(tbiot(i)-phi*kron(i))*skron(i)
        end do
    endif
!
999 continue
!
end subroutine
