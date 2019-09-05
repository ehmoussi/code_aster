! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1306
!
module Behaviour_module
! ==================================================================================================
use Behaviour_type
use calcul_module, only : ca_jvcnom_, ca_nbcvrc_
! ==================================================================================================
implicit none
! ==================================================================================================
private :: varcIsGEOM,&
           prepEltSize1, prepGradVelo, prepEltSize2, prepHygrometry
public  :: behaviourInit, behaviourInitPoint,&
           behaviourPrepExteElem, prepCoorGauss, behaviourPrepExteGauss
! ==================================================================================================
private
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/Behaviour_type.h"
#include "asterc/r8nnem.h"
#include "asterc/indik8.h"
#include "asterc/r8vide.h"
#include "asterfort/isdeco.h"
#include "asterfort/assert.h"
#include "asterfort/matinv.h"
#include "asterfort/nmgeom.h"
#include "asterfort/mgauss.h"
#include "asterfort/pmat.h"
#include "asterfort/utmess.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/rcvalb.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
! ==================================================================================================
contains
! ==================================================================================================
! --------------------------------------------------------------------------------------------------
!
! behaviourInit
!
! Initialisation of behaviour datastructure
!
! Out BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourInit(BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    type(Behaviour_Integ), intent(out) :: BEHinteg
!   ------------------------------------------------------------------------------------------------
    BEHinteg%elga%hygr_prev = r8nnem()
    BEHinteg%elga%hygr_curr = r8nnem()
    call varcIsGEOM(BEHinteg%l_varext_geom)
    BEHinteg%elem%coor_elga = r8nnem()
    BEHinteg%elem%eltsize1  = r8nnem()
    BEHinteg%elem%eltsize2  = r8nnem()
    BEHinteg%elem%gradvelo  = r8nnem()
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourInitPoint
!
! Initialisation of behaviour datastructure - Special for SIMU_POINT_MAT
!
! In  carcri           : parameters for comportment
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  imate            : coded material address
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourInitPoint(carcri, fami, kpg, ksp, imate, BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate
    type(Behaviour_Integ), intent(inout) :: BEHinteg
! - Local
!   ------------------------------------------------------------------------------------------------
    BEHinteg%elem%gradvelo  = 0.d0
    call behaviourPrepExteGauss(carcri, fami, kpg, ksp, imate, BEHinteg)
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourPrepExteElem
!
! Prepare external state variables - For element
!
! In  carcri           : parameters for comportment
! In  typmod           : type of modelisation
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  geom             : initial coordinates of nodes
! IO  BEHinteg         : parameters for integration of behaviour
! In  deplm            : displacements of nodes at beginning of time step
! In  ddepl            : displacements of nodes since beginning of time step
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourPrepExteElem(carcri  , typmod ,&
                                 nno     , npg    , ndim    ,&
                                 jv_poids, jv_func, jv_dfunc,&
                                 geom    , BEHinteg,&
                                 deplm_  , ddepl_)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    character(len=8), intent(in) :: typmod(2)
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_poids, jv_func, jv_dfunc
    real(kind=8), intent(in) :: geom(ndim, nno)
    type(Behaviour_Integ), intent(inout) :: BEHinteg
    real(kind=8), optional, intent(in) :: deplm_(ndim, nno), ddepl_(ndim, nno)
! - Local
    integer :: jvariext1, jvariext2
    integer :: tabcod(60), variextecode(2)
!   ------------------------------------------------------------------------------------------------
!
    jvariext1 = nint(carcri(IVARIEXT1))
    jvariext2 = nint(carcri(IVARIEXT2))
    tabcod(:) = 0
    variextecode(1) = jvariext1
    variextecode(2) = jvariext2
    call isdeco(variextecode, tabcod, 60)
!
! - Element size 1
!
    if (tabcod(ELTSIZE1) .eq. 1) then
        call prepEltSize1(nno     , npg    , ndim    ,&
                          jv_poids, jv_func, jv_dfunc,&
                          geom    , typmod , BEHinteg)
    endif
!
! - Element size 2
!
    if (tabcod(ELTSIZE2) .eq. 1) then
        call prepEltSize2(nno     , npg   , ndim,&
                          jv_dfunc,&
                          geom    , typmod, BEHinteg)
    endif
!
! - Gradient of velocity
!
    if (tabcod(GRADVELO) .eq. 1) then
        if (.not.present(deplm_) .or. .not.present(ddepl_)) then
            call utmess('F', 'COMPOR2_26')
        endif
        call prepGradVelo(nno     , npg    , ndim    ,&
                          jv_poids, jv_func, jv_dfunc,&
                          geom    , deplm_ , ddepl_  ,&
                          BEHinteg)
    endif
!
! - Coordinates of Gauss points
!
    call prepCoorGauss(nno    , npg , ndim    ,&
                       jv_func, geom, BEHinteg)
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourPrepExteGauss
!
! Prepare external state variables - For gauss point
!
! In  carcri           : parameters for comportment
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  imate            : coded material address
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourPrepExteGauss(carcri, fami, kpg, ksp, imate, BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate
    type(Behaviour_Integ), intent(inout) :: BEHinteg
! - Local
    integer :: jvariext1, jvariext2
    integer :: tabcod(60), variextecode(2)
!   ------------------------------------------------------------------------------------------------

    jvariext1 = nint(carcri(IVARIEXT1))
    jvariext2 = nint(carcri(IVARIEXT2))
    tabcod(:) = 0
    variextecode(1) = jvariext1
    variextecode(2) = jvariext2
    call isdeco(variextecode, tabcod, 60)
    if (tabcod(HYGR) .eq. 1) then
        call prepHygrometry(fami, kpg, ksp, imate, BEHinteg)
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepEltSize1
!
! Compute intrinsic external state variables - Size of element (ELTSIZE1)
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  typmod           : type of modelization (TYPMOD2)
! In  geom             : initial coordinates of nodes
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine prepEltSize1(nno     , npg    , ndim    ,&
                        jv_poids, jv_func, jv_dfunc,&
                        geom    , typmod , BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_poids, jv_func, jv_dfunc
    character(len=8), intent(in) :: typmod(2)
    real(kind=8), intent(in) :: geom(ndim, nno)
    type(Behaviour_Integ), intent(inout) :: BEHinteg
! - Local
    aster_logical :: l_axi
    integer :: kpg, k, i
    real(kind=8) :: lc, dfdx(27), dfdy(27), dfdz(27), poids, r
    real(kind=8) :: volume, surfac
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!   ------------------------------------------------------------------------------------------------
    l_axi = typmod(1) .eq. 'AXIS'
!
    if (typmod(1)(1:2) .eq. '3D') then
        volume = 0.d0
        do kpg = 1, npg
            call dfdm3d(nno, kpg, jv_poids, jv_dfunc, geom,&
                        poids, dfdx, dfdy, dfdz)
            volume = volume + poids
        end do
        if (npg .ge. 9) then
            lc = volume ** 0.33333333333333d0
        else
            lc = rac2 * volume ** 0.33333333333333d0
        endif
    elseif (typmod(1)(1:6).eq.'D_PLAN' .or. typmod(1)(1:4).eq.'AXIS') then
        surfac = 0.d0
        do kpg = 1, npg
            k = (kpg-1)*nno
            call dfdm2d(nno, kpg, jv_poids, jv_dfunc, geom,&
                        poids, dfdx, dfdy)
            if (l_axi) then
                r = 0.d0
                do i = 1, nno
                    r = r + geom(1,i)*zr(jv_func+i+k-1)
                end do
                poids = poids*r
            endif
            surfac = surfac + poids
        end do
!
        if (npg .ge. 5) then
            lc = surfac ** 0.5d0
        else
            lc = rac2 * surfac ** 0.5d0
        endif
!
    elseif (typmod(1)(1:6).eq.'C_PLAN') then
        lc = r8vide()
    else
        ASSERT(ASTER_FALSE)
    endif
!
    BEHinteg%elem%eltsize1 = lc
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepEltSize2
!
! Compute intrinsic external state variables - Size of element (ELTSIZE2)
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points
! In  ndim             : dimension of problem (2 or 3)
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  typmod2          : type of modelization (TYPMOD2)
! In  geom             : initial coordinates of nodes
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine prepEltSize2(nno     , npg , ndim  ,&
                        jv_dfunc, geom, typmod,&
                        BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_dfunc
    character(len=8), intent(in) :: typmod(2)
    real(kind=8), intent(in) :: geom(ndim, nno)
    type(Behaviour_Integ), intent(inout) :: BEHinteg
! - Local
    integer :: kpg, i, j, k, jj, iret
    real(kind=8) :: l(3, 3)
    real(kind=8) :: inv(3, 3), det, de, dn, dk
!   ------------------------------------------------------------------------------------------------
    if (typmod(1)(1:2) .eq. '3D') then
        do kpg = 1, npg
            do i = 1, 3
                l(1,i) = 0.d0
                l(2,i) = 0.d0
                l(3,i) = 0.d0
                do  j = 1, nno
                    k = 3*nno*(kpg-1)
                    jj = 3*(j-1)
                    de = zr(jv_dfunc-1+k+jj+1)
                    dn = zr(jv_dfunc-1+k+jj+2)
                    dk = zr(jv_dfunc-1+k+jj+3)
                    l(1,i) = l(1,i) + de*geom(i,j)
                    l(2,i) = l(2,i) + dn*geom(i,j)
                    l(3,i) = l(3,i) + dk*geom(i,j)
                end do
            end do
! --------- inversion de la matrice l
            iret = 0
            det  = 0.d0
            inv  = 0.d0
            do i = 1, 3
                inv(i,i) = 1.d0
            end do
            call mgauss('NCVP', l, inv, 3, 3,&
                        3, det, iret)
            do i = 1, 3
                do j = 1, 3
                    BEHinteg%elem%eltsize2(3*(i-1)+j)=inv(i,j)
                end do
            end do
        end do
    else
        BEHinteg%elem%eltsize2 = r8vide()
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepGradVelo
!
! Compute intrinsic external state variables - Gradient of velocity (GRADVELO)
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  geom             : initial coordinates of nodes
! In  deplm            : displacements of nodes at beginning of time step
! In  ddepl            : displacements of nodes since beginning of time step
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine prepGradVelo(nno     , npg    , ndim    ,&
                        jv_poids, jv_func, jv_dfunc,&
                        geom    , deplm  , ddepl   ,&
                        BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_poids, jv_func, jv_dfunc
    real(kind=8), intent(in) :: geom(ndim, nno)
    real(kind=8), intent(in) :: deplm(ndim, nno), ddepl(ndim, nno)
    type(Behaviour_Integ), intent(inout) :: BEHinteg
! - Local
    integer :: nddl, kpg, i, j
    real(kind=8) :: l(3, 3), fmm(3, 3), df(3, 3), f(3, 3), r8bid, r
    real(kind=8) :: deplp(3, 27), geomm(3, 27), epsbid(6)
    real(kind=8) :: dfdi(nno, 3)
    real(kind=8), parameter :: id(9) =(/1.d0,0.d0,0.d0, 0.d0,1.d0,0.d0, 0.d0,0.d0,1.d0/)
!   ------------------------------------------------------------------------------------------------
    nddl = ndim*nno
    BEHinteg%elem%gradvelo = 0.d0
!
    call dcopy(nddl, geom, 1, geomm, 1)
    call daxpy(nddl, 1.d0, deplm, 1, geomm, 1)
    call dcopy(nddl, deplm, 1, deplp, 1)
    call daxpy(nddl, 1.d0, ddepl, 1, deplp, 1)
    do kpg = 1, npg
        call nmgeom(ndim, nno, .false._1, .true._1, geom,&
                    kpg, jv_poids, jv_func, jv_dfunc, deplp,&
                    .true._1, r8bid, dfdi, f, epsbid,&
                    r)
        call nmgeom(ndim, nno, .false._1, .true._1, geomm,&
                    kpg, jv_poids, jv_func, jv_dfunc, ddepl,&
                    .true._1, r8bid, dfdi, df, epsbid,&
                    r)
        call daxpy(9, -1.d0, id, 1, df, 1)
        call matinv('S', 3, f, fmm, r8bid)
        call pmat(3, df, fmm, l)
        do i = 1, 3
            do j = 1, 3
                BEHinteg%elem%gradvelo(3*(i-1)+j) = l(i,j)
            end do
        end do
    end do
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepCoorGauss
!
! Compute intrinsic external state variables - Coordinates of Gauss points
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_func          : JEVEUX adress for shape functions
! In  geom             : initial coordinates of nodes
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine prepCoorGauss(nno    , npg , ndim    ,&
                         jv_func, geom, BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_func
    real(kind=8), intent(in) :: geom(ndim, nno)
    type(Behaviour_Integ), intent(inout) :: BEHinteg
! - Local
    integer :: i, k, kpg
!   ------------------------------------------------------------------------------------------------
    BEHinteg%elem%coor_elga = 0.d0
    ASSERT(npg .le. 27)
!
    do kpg = 1, npg
        do i = 1, ndim
            do k = 1, nno
                BEHinteg%elem%coor_elga(kpg, i) = BEHinteg%elem%coor_elga(kpg, i) +&
                                                  geom(i,k)*zr(jv_func-1+nno*(kpg-1)+k)
            end do
        end do
    end do
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! prepHygrometry
!
! Compute intrinsic external state variables - Hygrometry
!
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  imate            : coded material address
! IO  BEHinteg         : parameters for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
subroutine prepHygrometry(fami, kpg, ksp, imate, BEHinteg)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg, ksp, imate
    type(Behaviour_Integ), intent(inout) :: BEHinteg
! - Local
    integer           :: codret(1)
    real(kind=8)      :: valres(1)
    character(len=16) :: nomres(1)
!   ------------------------------------------------------------------------------------------------
    nomres(1) = 'FONC_DESORP'
    call rcvalb(fami, kpg, ksp, '-', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, nomres, valres, codret, 0)
    if (codret(1) .eq. 0) then
        BEHinteg%elga%hygr_prev = valres(1)
    else
        call utmess('F', 'COMPOR2_94')
    endif
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, nomres, valres, codret, 0)
    if (codret(1) .eq. 0) then
        BEHinteg%elga%hygr_curr = valres(1)
    else
        call utmess('F', 'COMPOR2_94')
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! varcIsGEOM
!
! Detect 'GEOM' in external state variables
!
! Out l_varext_geom    : flag for GEOM in external state variables (AFFE_VARC)
!
! --------------------------------------------------------------------------------------------------
subroutine varcIsGEOM(l_varext_geom)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    aster_logical, intent(inout) :: l_varext_geom
! - Local
    character(len=8), parameter :: varc_geom = 'X'
    integer :: varc_indx
!   ------------------------------------------------------------------------------------------------
   l_varext_geom = ASTER_FALSE
!
! - Detect 'GEOM' external state variables
    if (ca_nbcvrc_ .eq. 0) then
        l_varext_geom = ASTER_FALSE
    else
        varc_indx = indik8(zk8(ca_jvcnom_), varc_geom, 1, ca_nbcvrc_)
        l_varext_geom = varc_indx .ne. 0
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
!
end module Behaviour_module
