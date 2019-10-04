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
!
module Behaviour_module
! ==================================================================================================
use Behaviour_type
use calcul_module, only : ca_jvcnom_, ca_nbcvrc_
! ==================================================================================================
implicit none
! ==================================================================================================
private :: varcIsGEOM
public  :: behaviourInit,&
           behaviourPrepExternal
! ==================================================================================================
private
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/Behaviour_type.h"
#include "asterc/r8nnem.h"
#include "asterc/indik8.h"
#include "asterfort/isdeco.h"
#include "asterfort/calcExternalStateVariable1.h"
#include "asterfort/calcExternalStateVariable2.h"
#include "asterfort/calcExternalStateVariable3.h"
#include "asterfort/calcExternalStateVariable4.h"
#include "asterfort/utmess.h"
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
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG> Initialization of datastructures'
    endif
    BEHinteg%elga%coorpg = r8nnem()
    call varcIsGEOM(BEHinteg%l_varext_geom)
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! behaviourPrepExternal
!
! Prepare external state variables
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
! In  deplm            : displacements of nodes at beginning of time step
! In  ddepl            : displacements of nodes since beginning of time step
! Out coorga           : coordinates of all integration points
!
! --------------------------------------------------------------------------------------------------
subroutine behaviourPrepExternal(carcri  , typmod ,&
                                 nno     , npg    , ndim    ,&
                                 jv_poids, jv_func, jv_dfunc,&
                                 geom    , coorga ,&
                                 deplm_  , ddepl_)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    real(kind=8), intent(in) :: carcri(*)
    character(len=8), intent(in) :: typmod(2)
    integer, intent(in) :: nno, npg, ndim
    integer, intent(in) :: jv_poids, jv_func, jv_dfunc
    real(kind=8), intent(in) :: geom(ndim, nno)
    real(kind=8), intent(out) :: coorga(27,3)
    real(kind=8), optional, intent(in) :: deplm_(ndim, nno), ddepl_(ndim, nno)
! - Local
    integer :: jvariext1, jvariext2
    integer :: tabcod(60), variextecode(2)
!   ------------------------------------------------------------------------------------------------
    coorga = r8nnem()
!
! - Get coded integers for external state variables
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
        call calcExternalStateVariable1(nno     , npg    , ndim    ,&
                                        jv_poids, jv_func, jv_dfunc,&
                                        geom    , typmod )
    endif
!
! - Coordinates of Gauss points
!
    call calcExternalStateVariable2(nno    , npg   , ndim  ,&
                                    jv_func, &
                                    geom   , coorga)
!
! - Gradient of velocity
!
    if (tabcod(GRADVELO) .eq. 1) then
        if (.not.present(deplm_) .or. .not.present(ddepl_)) then
            call utmess('F', 'COMPOR2_26')
        endif
        call calcExternalStateVariable3(nno     , npg    , ndim    ,&
                                        jv_poids, jv_func, jv_dfunc,&
                                        geom    , deplm_ , ddepl_ )
    endif
!
! - Element size 2
!
    if (tabcod(ELTSIZE2) .eq. 1) then
        call calcExternalStateVariable4(nno     , npg   , ndim,&
                                        jv_dfunc,&
                                        geom    , typmod)
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
!
    if (LDC_PREP_DEBUG .eq. 1) then
        WRITE(6,*) '<DEBUG> Detect GEOM in external state variables: ',l_varext_geom
    endif
!   ------------------------------------------------------------------------------------------------
end subroutine
!
end module Behaviour_module
