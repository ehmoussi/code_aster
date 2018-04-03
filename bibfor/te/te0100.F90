! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine te0100(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmdlog.h"
#include "asterfort/nmed2d.h"
#include "asterfort/nmel2d.h"
#include "asterfort/nmgpfi.h"
#include "asterfort/nmgr2d.h"
#include "asterfort/nmpl2d.h"
#include "asterfort/nmtstm.h"
#include "asterfort/rcangm.h"
#include "asterfort/tecach.h"
#include "asterfort/tgveri.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
#include "blas/dcopy.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: D_PLAN, C_PLAN, AXIS
!           AXIS_SI, C_PLAN_SI (QUAD8), D_PLAN_SI (QUAD8)
!           AXIS_ELDI, PLAN_ELDI
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
    character(len=8) :: typmod(2)
    character(len=4) :: fami
    integer :: nno, npg, i, imatuu, lgpg
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: icontm, ivarim
    integer :: iinstm, iinstp, ideplm, ideplp, icompo, icarcr
    integer :: ivectu, icontp, ivarip, li
    integer :: ivarix, iret, jv_mult_comp
    integer :: jtab(7), jcret, codret
    integer :: ndim, idim
    real(kind=8) :: vect1(54), vect2(4*27*27), vect3(4*27*2), dfdi(4*9)
    real(kind=8) :: angl_naut(7), bary(3)
    aster_logical :: matsym
    character(len=16) :: mult_comp, defo_comp, rela_comp, type_comp
!     POUR TGVERI
    real(kind=8) :: sdepl(3*9), svect(3*9), scont(6*9), smatr(3*9*3*9), epsilo
    real(kind=8) :: varia(2*3*9*3*9)
!
! --------------------------------------------------------------------------------------------------
!
    icontp = 1
    ivarip = 1
    imatuu = 1
    ivectu = 1
    fami   = 'RIGI'
!
! - Get element parameters
!
    call elrefe_info(fami=fami, ndim=ndim, nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    ASSERT(nno .le. 9)
!
! - Type of finite element
!
    if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS'
    else if (lteatt('C_PLAN','OUI')) then
        typmod(1) = 'C_PLAN'
    else if (lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN'
    else
        ASSERT(lteatt('C_PLAN', 'OUI'))
    endif
!
    if (lteatt('TYPMOD2','ELEMDISC')) then
        typmod(2) = 'ELEMDISC'
    else
        typmod(2) = ' '
    endif
    codret = 0
!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PDEPLMR', 'L', ideplm)
    call jevech('PDEPLPR', 'L', ideplp)
    call jevech('PCOMPOR', 'L', icompo)
    call jevech('PCARCRI', 'L', icarcr)
    call jevech('PMULCOM', 'L', jv_mult_comp)
    mult_comp = zk16(jv_mult_comp-1+1)
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,&
                itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! - Compute barycentric center
!
    bary(:) = 0.d0
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
! - Properties of behaviour
!
    rela_comp = zk16(icompo-1+RELA_NAME)
    defo_comp = zk16(icompo-1+DEFO)
    type_comp = zk16(icompo-1+INCRELAS)
!
! - Get output fields
!
    if (option(1:10) .eq. 'RIGI_MECA_' .or. option(1:9) .eq. 'FULL_MECA') then
        call nmtstm(zr(icarcr), imatuu, matsym)
    endif
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call jevech('PVECTUR', 'E', ivectu)
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PVARIMP', 'L', ivarix)
        call dcopy(npg*lgpg, zr(ivarix), 1, zr(ivarip), 1)
    else
        ivarix=1
    endif
    if (option(1:16) .eq. 'RIGI_MECA_IMPLEX') then
        call jevech('PCONTXR', 'E', icontp)
        call dcopy(npg*4, zr(icontm), 1, zr(icontp), 1)
    endif
!
! - Check
!
    if (defo_comp .eq. 'GROT_GDEP') then
        if (lteatt('C_PLAN','OUI') .and. rela_comp .eq. 'ELAS') then
            call utmess('F', 'COMPOR1_15')
        endif
    endif
!
! - HYPER-ELASTICITE
!
    if (type_comp .eq. 'COMP_ELAS') then
        if (option(1:10) .eq. 'RIGI_MECA_') then
            call nmel2d(fami, '-', nno, npg, ipoids,&
                        ivf, idfde, zr(igeom), typmod, option,&
                        zi(imate), zk16(icompo), lgpg, zr(icarcr), ideplm,&
                        angl_naut, vect1, vect2, vect3, zr(icontm),&
                        zr(ivarim), zr(imatuu), ivectu, codret)
        else
            do li = 1, 2*nno
                zr(ideplp+li-1) = zr(ideplm+li-1) + zr(ideplp+li-1)
            end do
            call nmel2d(fami, '+', nno, npg, ipoids,&
                        ivf, idfde, zr(igeom), typmod, option,&
                        zi(imate), zk16(icompo), lgpg, zr(icarcr), ideplp,&
                        angl_naut, vect1, vect2, vect3, zr(icontp),&
                        zr(ivarip), zr(imatuu), ivectu, codret)
        endif
    else
!
! - HYPO-ELASTICITE
!
!      Pour le calcul de la matrice tangente par perturbation
500     continue
!
        if (defo_comp(1:5) .eq. 'PETIT') then
            if (defo_comp(6:10) .eq. '_REAC') then
                do i = 1, 2*nno
                    zr(igeom+i-1) = zr(igeom+i-1) + zr(ideplm+i-1) + zr(ideplp+i-1)
                end do
            endif
            if (typmod(2) .eq. 'ELEMDISC') then
                call nmed2d(nno, npg, ipoids, ivf, idfde,&
                            zr(igeom), typmod, option, zi(imate), zk16(icompo),&
                            lgpg, zr(icarcr), ideplm, ideplp, zr(icontm),&
                            zr(ivarim), vect1, vect3, zr( icontp), zr(ivarip),&
                            zr(imatuu), ivectu, codret)
            else
                call nmpl2d(fami, nno, npg, ipoids, ivf,&
                            idfde, zr(igeom), typmod, option, zi(imate),&
                            zk16(icompo), mult_comp, lgpg, zr(icarcr), zr(iinstm), zr(iinstp),&
                            ideplm, ideplp, angl_naut, zr( icontm), zr(ivarim),&
                            matsym, vect1, vect3, zr(icontp), zr( ivarip),&
                            zr(imatuu), ivectu, codret)
            endif
        else if (defo_comp .eq. 'SIMO_MIEHE') then
            call nmgpfi(fami, option, typmod, ndim, nno,&
                        npg, ipoids, zr( ivf), idfde, zr(igeom),&
                        dfdi, zk16(icompo), zi(imate), mult_comp, lgpg, zr( icarcr),&
                        angl_naut, zr(iinstm), zr(iinstp), zr(ideplm), zr( ideplp),&
                        zr(icontm), zr(ivarim), zr(icontp), zr(ivarip), zr( ivectu),&
                        zr(imatuu), codret)
        else if (defo_comp .eq. 'GROT_GDEP') then
            call nmgr2d(option      , typmod    ,&
                        fami        , zi(imate) ,&
                        nno         , npg       , lgpg     ,&
                        ipoids      , ivf       , zr(ivf)  , idfde,&
                        zk16(icompo), zr(icarcr), mult_comp,&
                        zr(iinstm)  , zr(iinstp),&
                        zr(igeom)   , zr(ideplm),&
                        zr(ideplp)  ,&
                        zr(icontm)  , zr(icontp),&
                        zr(ivarim)  , zr(ivarip),&
                        matsym      , zr(imatuu), zr(ivectu),&
                        codret)
        else if (defo_comp .eq. 'GDEF_LOG') then
            call nmdlog(fami, option, typmod, ndim, nno,&
                        npg, ipoids, ivf, zr(ivf), idfde,&
                        zr(igeom), dfdi, zk16(icompo), mult_comp, zi(imate), lgpg,&
                        zr(icarcr), angl_naut, zr(iinstm), zr(iinstp), matsym,&
                        zr( ideplm), zr(ideplp), zr(icontm), zr(ivarim), zr(icontp),&
                        zr( ivarip), zr(ivectu), zr(imatuu), codret)
        else
            ASSERT(ASTER_FALSE)
        endif
!
        if (codret .ne. 0) goto 999
! ----- Calcul eventuel de la matrice TGTE par PERTURBATION
        call tgveri(option, zr(icarcr), zk16(icompo), nno, zr(igeom),&
                    ndim, ndim*nno, zr(ideplp), sdepl, zr(ivectu),&
                    svect, 4*npg, zr(icontp), scont, npg*lgpg,&
                    zr(ivarip), zr(ivarix), zr(imatuu), smatr, matsym,&
                    epsilo, varia, iret)
        if (iret .ne. 0) goto 500
!
    endif
!
999 continue
!
    if (option(1:9) .eq. 'FULL_MECA' .or. option(1:9) .eq. 'RAPH_MECA') then
        call jevech('PCODRET', 'E', jcret)
        zi(jcret) = codret
    endif
!
end subroutine
