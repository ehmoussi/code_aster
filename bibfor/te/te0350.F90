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
!
subroutine te0350(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmas2d.h"
#include "asterfort/rcangm.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "blas/dcopy.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: C_PLAN_SI / D_PLAN_SI (for QUAD4)
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: mult_comp, defo_comp, rela_comp, type_comp
    aster_logical :: lVect, lMatr, lVari, lSigm
    character(len=8) :: typmod(2)
    character(len=4), parameter :: fami  = 'RIGI'
    integer :: nno, npg, i, imatuu, lgpg, ndim
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: icontm, ivarim, jv_mult_comp
    integer :: iinstm, iinstp, ideplm, ideplp, icompo, icarcr
    integer :: ivectu, icontp, ivarip
    integer :: ivarix, iret, idim
    integer :: jtab(7), jcret, codret
    real(kind=8) :: def(4*27*2), dfdi(54)
    real(kind=8) :: angl_naut(7), bary(3)
!
! --------------------------------------------------------------------------------------------------
!
    imatuu = 1
    ivectu = 1
    icontp = 1
    ivarip = 1
    codret = 0
!
! - Get element parameters
!
    call elrefe_info(fami=fami,ndim=ndim,nno=nno,&
                      npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde)
    ASSERT(nno .eq. 4)
!
! - Type of finite element
!
    if (lteatt('C_PLAN','OUI')) then
        typmod(1) = 'C_PLAN'
    else if (lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN'
    else
        ASSERT(ASTER_FALSE)
    endif
    typmod(2) = ' '
!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PDEPLPR', 'L', ideplp)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PCARCRI', 'L', icarcr)
    call jevech('PMULCOM', 'L', jv_mult_comp)
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! - Compute barycentric center
!
    bary = 0.d0
    do i = 1, nno
        do idim = 1, ndim
            bary(idim) = bary(idim)+zr(igeom+idim+ndim*(i-1)-1)/nno
        end do
    end do
!
! - Get orientation
!
    call rcangm(ndim, bary, angl_naut)
!
! - Select objects to construct from option name
!
    call behaviourOption(option, zk16(icompo),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! - Properties of behaviour
!
    mult_comp = zk16(jv_mult_comp-1+1)
    rela_comp = zk16(icompo-1+RELA_NAME)
    defo_comp = zk16(icompo-1+DEFO)
    type_comp = zk16(icompo-1+INCRELAS)
!
! - Get output fields
!
    if (lMatr) then
        call jevech('PMATUUR', 'E', imatuu)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PCODRET', 'E', jcret)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PVARIMP', 'L', ivarix)
        call dcopy(npg*lgpg, zr(ivarix), 1, zr(ivarip), 1)
    endif
!
! - HYPER-ELASTICITE
!
    if (type_comp .eq. 'COMP_ELAS') then
        if (rela_comp .ne. 'ELAS') then
            call utmess('F', 'ELEMENTSSI_2')
        endif
    endif
!
! - HYPO-ELASTICITE
!
    if (defo_comp (6:10) .eq. '_REAC') then
        do i = 1, ndim*nno
            zr(igeom+i-1) = zr(igeom+i-1) + zr(ideplm+i-1) + zr(ideplp+i-1)
        end do
    endif
!
    if (defo_comp(1:5) .eq. 'PETIT') then
        call nmas2d(fami, nno, npg, ipoids, ivf,&
                    idfde, zr(igeom), typmod, option, zi(imate),&
                    zk16(icompo), mult_comp, lgpg, zr(icarcr), zr(iinstm), zr(iinstp),&
                    zr(ideplm), zr(ideplp), angl_naut, zr(icontm), zr(ivarim),&
                    dfdi, def, zr(icontp), zr(ivarip), zr(imatuu),&
                    zr(ivectu), codret)
    else
        call utmess('F', 'ELEMENTSSI_1', sk=defo_comp)
    endif
!
! - Save return code
!
    if (lSigm) then
        zi(jcret) = codret
    endif
!
end subroutine
