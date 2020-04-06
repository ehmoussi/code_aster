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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine te0595(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elref2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/niinit.h"
#include "asterfort/nmtstm.h"
#include "asterfort/nofipd.h"
#include "asterfort/nufilg.h"
#include "asterfort/nufipd.h"
#include "asterfort/rcangm.h"
#include "asterfort/teattr.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_INCO_UP/3D_INCO_UPO
!           AXIS_INCO_UP/AXIS_INCO_UPO
!           D_PLAN_INCO_UP/D_PLAN_INCO_UPO
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
    aster_logical :: mini, matsym
    integer :: ndim, nnod, nnop, npg, ntrou
    integer :: icoret, codret, iret
    integer :: iw, ivfd, ivfp, idfd
    integer :: jtab(7), lgpg, i, idim
    integer :: vu(3, 27), vg(27), vp(27), vpi(3, 27)
    integer :: igeom, imate, icontm, ivarim
    integer :: iinstm, iinstp, iddlm, iddld, icompo, icarcr
    integer :: ivectu, icontp, ivarip, imatuu
    integer :: nddl, ibid
    real(kind=8) :: angmas(7), bary(3)
    character(len=8) :: lielrf(10), typmod(2), alias8
    character(len=16) :: defo_comp
    aster_logical :: lMatr, lVect, lVari, lSigm
!
! --------------------------------------------------------------------------------------------------
!
    icontp = 1
    ivarip = 1
    imatuu = 1
    ivectu = 1
    codret = 0
    matsym = ASTER_TRUE
    mini   = ASTER_FALSE
!
! - Get element parameters
!
    call elref2(nomte, 10, lielrf, ntrou)
    ASSERT(ntrou .ge. 2)
    call elrefe_info(elrefe=lielrf(2), fami='RIGI',&
                     ndim=ndim, nno=nnop, npg=npg,&
                     jpoids=iw, jvf=ivfp)
    call elrefe_info(elrefe=lielrf(1), fami='RIGI', ndim=ndim, nno=nnod, npg=npg,&
                     jpoids=iw, jvf=ivfd, jdfde=idfd)
!
! - Type of finite element
!
    if (ndim .eq. 2 .and. lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS  '
    else if (ndim.eq.2 .and. lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN  '
    else if (ndim .eq. 3) then
        typmod(1) = '3D'
    else
        ASSERT(ASTER_FALSE)
    endif
    typmod(2) = '        '
!
! - MINI ELEMENT ?
!
    mini = ASTER_FALSE
    call teattr('S', 'ALIAS8', alias8, ibid)
    if (alias8(6:8) .eq. 'TR3' .or. alias8(6:8) .eq. 'TE4') then
        mini = ASTER_TRUE
    endif
!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDEPLMR', 'L', iddlm)
    call jevech('PDEPLPR', 'L', iddld)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PCARCRI', 'L', icarcr)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! - Compute barycentric center
!
    bary = 0.d0
    do i = 1, nnod
        do idim = 1, ndim
            bary(idim) = bary(idim)+zr(igeom+idim+ndim*(i-1)-1)/nnod
        end do
    end do
!
! - Get orientation
!
    call rcangm(ndim, bary, angmas)
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
    defo_comp = zk16(icompo-1+DEFO)
!
! - Get output fields
!
    if (lMatr) then
        matsym = ASTER_TRUE
        if (defo_comp .eq. 'PETIT') then
            call jevech('PMATUUR', 'E', imatuu)
        elseif (defo_comp .eq. 'GDEF_LOG') then
            call nmtstm(zr(icarcr), imatuu, matsym)
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
    endif
!
! - Compute options
!
    if (defo_comp .eq. 'PETIT') then
        if (lteatt('INCO','C2 ')) then
! --------- Get index of dof
            call niinit(typmod, ndim, nnod, 0,&
                        nnop, 0, vu, vg, vp,&
                        vpi)
            nddl = nnod*ndim + nnop
            call nufipd(ndim, nnod, nnop, npg, iw,&
                        zr(ivfd), zr(ivfp), idfd, vu, vp,&
                        zr(igeom), typmod, option, zi(imate), zk16(icompo),&
                        lgpg, zr(icarcr), zr(iinstm), zr(iinstp), zr(iddlm),&
                        zr(iddld), angmas, zr(icontm), zr(ivarim), zr(icontp),&
                        zr(ivarip), mini, zr(ivectu),&
                        zr(imatuu), codret,&
                        lSigm, lVect, lMatr)
        else if (lteatt('INCO','C2O')) then
! --------- Get index of dof
            call niinit(typmod, ndim, nnod, 0,&
                        nnop, nnop, vu, vg, vp,&
                        vpi)
            nddl = nnod*ndim + nnop + nnop*ndim
            call nofipd(ndim, nnod, nnop, nnop, npg,&
                        iw, zr(ivfd), zr(ivfp), zr(ivfp), idfd,&
                        vu, vp, vpi, zr(igeom), typmod,&
                        option, nomte, zi(imate), zk16(icompo), lgpg,&
                        zr(icarcr), zr(iinstm), zr(iinstp), zr(iddlm), zr(iddld),&
                        angmas, zr(icontm), zr(ivarim), zr(icontp), zr(ivarip),&
                        zr(ivectu), zr(imatuu), codret,&
                        lSigm, lVect, lMatr)
        else
            ASSERT(ASTER_FALSE)
        endif
    else if (defo_comp .eq. 'GDEF_LOG') then
        if (lteatt('INCO','C2 ')) then
            ASSERT(.not. mini)
! --------- Get index of dof
            call niinit(typmod, ndim, nnod, 0,&
                        nnop, 0, vu, vg, vp,&
                        vpi)
            nddl = nnod*ndim + nnop
            call nufilg(ndim, nnod, nnop, npg, iw,&
                        zr(ivfd), zr(ivfp), idfd, vu, vp,&
                        zr(igeom), typmod, option, zi(imate), zk16(icompo),&
                        lgpg, zr(icarcr), zr(iinstm), zr(iinstp), zr(iddlm),&
                        zr(iddld), angmas, zr(icontm), zr(ivarim), zr(icontp),&
                        zr(ivarip), zr(ivectu), zr(imatuu),&
                        matsym, codret,&
                        lVect, lMatr)
        else
            ASSERT(ASTER_FALSE)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Save return code
!
    if (lSigm) then
        call jevech('PCODRET', 'E', icoret)
        zi(icoret) = codret
    endif
!
end subroutine
