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

function lcgtn_material(fami,kpg,ksp,imate,resi,grvi) result(mat)

    use lcgtn_module, only: gtn_material

    implicit none
#include "asterf_types.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"


    aster_logical, intent(in) :: grvi,resi
    character(len=*),intent(in) :: fami
    integer,intent(in) :: imate, kpg, ksp
    type(gtn_material) :: mat 
! ----------------------------------------------------------------------
!  LOI GTN - LECTURE DES PARAMETRES MATERIAUX
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer,parameter:: nbel=2, nbnl=2, nben=8, nbec=9, nbvs=4
! ----------------------------------------------------------------------
    integer :: iok(nbel+nbnl+nben+nbec+nbvs)
    real(kind=8) :: valel(nbel), valen(nben),valnl(nbnl),valec(nbec),valvs(nbvs)
    character(len=16) :: nomel(nbel), nomen(nben),nomnl(nbnl),nomec(nbec),nomvs(nbvs)
    character(len=1) :: poum
! ----------------------------------------------------------------------
    data nomel /'E','NU'/
    data nomen /'Q1','Q2','PORO_INIT','COAL_PORO','COAL_ACCE','NUCL_PORO','NUCL_PLAS','NUCL_DEV'/
    data nomec /'R0','RH','R1','GAMMA_1','R2','GAMMA_2','RK','P0','GAMMA_M'/
    data nomnl /'C_GRAD_VARI','PENA_LAGR'/
    data nomvs /'SIGM_0','EPSI_0','M','DELTA'/
! ----------------------------------------------------------------------

    poum   = merge('+','-',resi)

!  Elasticity
    call rcvalb(fami,kpg,ksp,poum,imate,' ','ELAS',0,' ',[0.d0],nbel,nomel,valel,iok,2)
    mat%lambda = valel(1)*valel(2)/((1+valel(2))*(1-2*valel(2)))
    mat%deuxmu = valel(1)/(1+valel(2))
    mat%troismu = 1.5d0*mat%deuxmu
    mat%troisk = valel(1)/(1.d0-2.d0*valel(2))

!  Hardening
    call rcvalb(fami,kpg,ksp,poum,imate,' ','ECRO_NL',0,' ',[0.d0],nbec,nomec,valec,iok,2)
    mat%r0 = valec(1)
    mat%rh = valec(2)
    mat%r1 = valec(3)
    mat%g1 = valec(4)
    mat%r2 = valec(5)
    mat%g2 = valec(6)
    mat%rk = valec(7)
    mat%p0 = valec(8)
    mat%gk = valec(9)
    
!  GTN
    call rcvalb(fami,kpg,ksp,poum,imate,' ','GTN', 0,' ',[0.d0],nben,nomen,valen,iok,2)
    mat%q1 = valen(1)
    mat%q2 = valen(2)
    mat%f0 = valen(3)
    mat%fc = valen(4)
    mat%fr = mat%fc + (1.d0/mat%q1-mat%fc)/valen(5)
    mat%fn = valen(6)
    mat%pn = valen(7)
    mat%sn = valen(8)

!  Viscosity
    call rcvalb(fami,kpg,ksp,poum,imate,' ','VISC_SINH_REG',0,' ',[0.d0],nbvs,nomvs,valvs,iok,0)
    mat%vs0 = merge(valvs(1),0.d0,iok(1).eq.0)
    mat%ve0 = merge(valvs(2),1.d0,iok(2).eq.0)
    mat%vm  = merge(valvs(3),0.5d0,iok(3).eq.0)
    mat%vd  = merge(valvs(4),1.d0,iok(4).eq.0)
    
!  Nonlocal
    if (grvi) then
        call rcvalb(fami,kpg,ksp,poum,imate,' ','NON_LOCAL',0,' ',[0.d0],nbnl,nomnl,valnl,iok,2)
        mat%c     = valnl(1)
        mat%r     = valnl(2)
    else
        mat%c = 0
        mat%r = 0
    end if

end function
