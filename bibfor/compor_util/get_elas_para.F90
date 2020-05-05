! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1504
!
subroutine get_elas_para(fami    , j_mater, poum, ipg, ispg, &
                         elas_id , elas_keyword,&
                         time    , temp,&
                         e_      , nu_  , g_   ,&
                         e1_     , e2_  , e3_  ,&
                         nu12_   , nu13_, nu23_,&
                         g1_     , g2_  , g3_  ,&
                         BEHinteg, xyzgau_)
!
use Behaviour_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/hypmat.h"
#include "asterfort/rcvalb.h"
!
character(len=*), intent(in) :: fami
integer, intent(in) :: j_mater
character(len=*), intent(in) :: poum
integer, intent(in) :: ipg, ispg
integer, intent(in) :: elas_id
character(len=16), intent(in) :: elas_keyword
real(kind=8), optional, intent(in) :: time
real(kind=8), optional, intent(in) :: temp
real(kind=8), optional, intent(in) :: xyzgau_(3)
real(kind=8), optional, intent(out) :: e_, nu_, g_
real(kind=8), optional, intent(out) :: e1_,e2_, e3_
real(kind=8), optional, intent(out) :: nu12_, nu13_, nu23_
real(kind=8), optional, intent(out) :: g1_, g2_, g3_
type(Behaviour_Integ), optional, intent(in) :: BEHinteg
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility
!
! Get elastic parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  fami             : Gauss family for integration point rule
! In  j_mater          : coded material address
! In  time             : current time
! In  time             : current temperature
! In  poum             : '-' or '+' for parameters evaluation (previous or current temperature)
! In  ipg              : current point gauss
! In  ispg             : current "sous-point" gauss
! In  elas_id          : Type of elasticity
!                 1 - Isotropic
!                 2 - Orthotropic
!                 3 - Transverse isotropic
! In  elas_keyword     : keyword factor linked to type of elasticity parameters
! Out e                : Young modulus (isotropic)
! Out nu               : Poisson ratio (isotropic)
! Out e1               : Young modulus - Direction 1 (Orthotropic/Transverse isotropic)
! Out e2               : Young modulus - Direction 2 (Orthotropic)
! Out e3               : Young modulus - Direction 3 (Orthotropic/Transverse isotropic)
! Out nu12             : Poisson ratio - Coupling 1/2 (Orthotropic/Transverse isotropic)
! Out nu13             : Poisson ratio - Coupling 1/3 (Orthotropic/Transverse isotropic)
! Out nu23             : Poisson ratio - Coupling 2/3 (Orthotropic)
! Out g1               : shear ratio (Orthotropic)
! Out g2               : shear ratio (Orthotropic)
! Out g3               : shear ratio (Orthotropic)
! Out g                : shear ratio (isotropic/Transverse isotropic)
! In  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbresm = 9
    integer :: icodre(nbresm)
    character(len=16) :: nomres(nbresm)
    real(kind=8) :: valres(nbresm)
!
    character(len=8) :: para_name(5)
    real(kind=8) :: para_vale(5)
    integer :: nbres, nb_para
    real(kind=8), parameter :: un = 1.d0
    real(kind=8) :: c10, c01, c20, k
    real(kind=8) :: e, nu, g
    real(kind=8) :: e1, e2, e3
    real(kind=8) :: nu12, nu13, nu23
    real(kind=8) :: g1, g2, g3
!
! --------------------------------------------------------------------------------------------------
!
    nb_para    = 0
    para_name  = ' '
    para_vale  = 0.d0
    if (present(time)) then
        nb_para   = nb_para + 1
        para_name(nb_para) = 'INST'
        para_vale(nb_para) = time
    endif
    if (present(temp)) then
        nb_para   = nb_para + 1
        para_name(nb_para) = 'TEMP'
        para_vale(nb_para) = temp
    endif
    if (present(xyzgau_)) then
            nb_para   = nb_para + 1
            para_name(nb_para) = 'X'
            para_vale(nb_para) = xyzgau_(1)
            nb_para   = nb_para + 1
            para_name(nb_para) = 'Y'
            para_vale(nb_para) = xyzgau_(2)
            nb_para   = nb_para + 1
            para_name(nb_para) = 'Z'
            para_vale(nb_para) = xyzgau_(3)
    endif
    if (present(BEHinteg)) then
        if (.not.BEHinteg%l_varext_geom) then
            nb_para   = nb_para + 1
            para_name(nb_para) = 'X'
            para_vale(nb_para) = BEHinteg%elem%coor_elga(ipg,1)
            nb_para   = nb_para + 1
            para_name(nb_para) = 'Y'
            para_vale(nb_para) = BEHinteg%elem%coor_elga(ipg,2)
            nb_para   = nb_para + 1
            para_name(nb_para) = 'Z'
            para_vale(nb_para) = BEHinteg%elem%coor_elga(ipg,3)
        endif
    endif
!
! - Get elastic parameters
!
    if (elas_id .eq. 1) then
        if (elas_keyword.eq.'ELAS_HYPER') then
            call hypmat(fami, ipg, ispg, poum, j_mater,&
                        c10, c01, c20, k)
            nu = (3.d0*k-4.0d0*(c10+c01))/(6.d0*k+4.0d0*(c10+c01))
            e  = 4.d0*(c10+c01)*(un+nu)
        else
            nomres(1) = 'E'
            nomres(2) = 'NU'
            nbres     = 2
            call rcvalb(fami, ipg, ispg, poum, j_mater,&
                        ' ', elas_keyword, nb_para, para_name, [para_vale],&
                        nbres, nomres, valres, icodre, 1)
            e  = valres(1)
            nu = valres(2)
        endif
        g = 1.d0/((1.d0+nu)*(1.d0-2.d0*nu))
    elseif (elas_id .eq. 2) then
        nomres(1) = 'E_L'
        nomres(2) = 'E_T'
        nomres(3) = 'E_N'
        nomres(4) = 'NU_LT'
        nomres(5) = 'NU_LN'
        nomres(6) = 'NU_TN'
        nomres(7) = 'G_LT'
        nomres(8) = 'G_LN'
        nomres(9) = 'G_TN'
        nbres     = 9
        call rcvalb(fami, ipg, ispg, poum, j_mater,&
                    ' ', elas_keyword, nb_para, para_name, [para_vale],&
                    nbres, nomres, valres, icodre, 1)
        e1 = valres(1)
        e2 = valres(2)
        e3 = valres(3)
        nu12 = valres(4)
        nu13 = valres(5)
        nu23 = valres(6)
        g1 = valres(7)
        g2 = valres(8)
        g3 = valres(9)
    elseif (elas_id .eq. 3) then
        nomres(1) = 'E_L'
        nomres(2) = 'E_N'
        nomres(3) = 'NU_LT'
        nomres(4) = 'NU_LN'
        nomres(5) = 'G_LN'
        nbres     = 5
        call rcvalb(fami, ipg, ispg, poum, j_mater,&
                    ' ', elas_keyword, nb_para, para_name, [para_vale],&
                    nbres, nomres, valres, icodre, 1)
        e1   = valres(1)
        e3   = valres(2)
        nu12 = valres(3)
        nu13 = valres(4)
        g    = valres(5)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Output
    if (present(e_)) then
        e_ = e
    endif
    if (present(nu_)) then
        nu_ = nu
    endif
    if (present(g_)) then
        g_ = g
    endif
    if (present(e1_)) then
        e1_ = e1
    endif
    if (present(e2_)) then
        e2_ = e2
    endif
    if (present(e3_)) then
        e3_ = e3
    endif
    if (present(g1_)) then
        g1_ = g1
    endif
    if (present(g2_)) then
        g2_ = g2
    endif
    if (present(g3_)) then
        g3_ = g3
    endif
    if (present(nu12_)) then
        nu12_ = nu12
    endif
    if (present(nu13_)) then
        nu13_ = nu13
    endif
    if (present(nu23_)) then
        nu23_ = nu23
    endif
end subroutine
