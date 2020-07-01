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
subroutine te0139(option, nomte)
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
#include "asterfort/nmdlog.h"
#include "asterfort/nmel3d.h"
#include "asterfort/nmgpfi.h"
#include "asterfort/nmgr3d.h"
#include "asterfort/nmpl3d.h"
#include "asterfort/nmtstm.h"
#include "asterfort/rcangm.h"
#include "asterfort/tecach.h"
#include "asterfort/tgveri.h"
#include "asterfort/Behaviour_type.h"
#include "blas/dcopy.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D
!           3D_SI (HEXA20)
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
    integer, parameter :: sz_tens = 6, ndim = 3
    integer :: i_node, i_dime, i
    integer :: nno, npg, imatuu, lgpg, iret
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: icontm, ivarim
    integer :: iinstm, iinstp, ideplm, ideplp, icompo, icarcr
    integer :: ivectu, icontp, ivarip
    integer :: ivarix, jv_mult_comp
    integer :: jtab(7)
    real(kind=8) :: bary(3)
    real(kind=8) :: dfdi(3*27)
    real(kind=8) :: angl_naut(7)
    aster_logical :: matsym
    character(len=16) :: mult_comp, defo_comp, rela_comp, type_comp
    aster_logical :: lVect, lMatr, lVari, lSigm
    integer :: codret
    integer :: jv_codret
!     POUR TGVERI
    real(kind=8) :: sdepl(3*27), svect(3*27), scont(6*27), smatr(3*27*3*27)
    real(kind=8) :: epsilo
    real(kind=8) :: varia(2*3*27*3*27)
!
! --------------------------------------------------------------------------------------------------
!
    icontp = 1
    ivarip = 1
    imatuu = 1
    ivectu = 1
    ivarix = 1
    jv_codret = 1
    fami   = 'RIGI'
    codret = 0
!
! - Get element parameters
!
    call elrefe_info(fami=fami, nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
    ASSERT(nno .le. 27)
!
! - Type of finite element
!
    typmod(1) = '3D'
    typmod(2) = ' '
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
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! - Compute barycentric center
!
    bary(:) = 0.d0
    do i_node = 1, nno
        do i_dime = 1, ndim
            bary(i_dime) = bary(i_dime)+zr(igeom+i_dime+ndim*(i_node-1)-1)/nno
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
        call nmtstm(zr(icarcr), imatuu, matsym)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
        call jevech('PVARIMP', 'L', ivarix)
        call dcopy(npg*lgpg, zr(ivarix), 1, zr(ivarip), 1)
    endif
    if (option .eq. 'RIGI_MECA_IMPLEX') then
        call jevech('PCONTXR', 'E', icontp)
        call dcopy(npg*sz_tens, zr(icontm), 1, zr(icontp), 1)
    endif
!
! - HYPER-ELASTICITE
!
    if (type_comp .eq. 'COMP_ELAS') then
        if (option(1:10) .eq. 'RIGI_MECA_') then
            call nmel3d(fami        , '-'       , nno       , npg       ,&
                        ipoids      , ivf       , idfde     ,&
                        zr(igeom)   , typmod    , option    , zi(imate) ,&
                        zk16(icompo), lgpg      , zr(icarcr), zr(ideplm),&
                        angl_naut   , zr(icontm), zr(ivarim),&
                        zr(imatuu)  , zr(ivectu), codret)
        else
            do i = 1, ndim*nno
                zr(ideplp+i-1) = zr(ideplm+i-1) + zr(ideplp+i-1)
            end do
            call nmel3d(fami        , '+'       , nno       , npg       ,&
                        ipoids      , ivf       , idfde     ,&
                        zr(igeom)   , typmod    , option    , zi(imate) ,&
                        zk16(icompo), lgpg      , zr(icarcr), zr(ideplp),&
                        angl_naut   , zr(icontp), zr(ivarip),&
                        zr(imatuu)  , zr(ivectu), codret)
        endif
    else
!
! - HYPO-ELASTICITE
!
!       Pour le calcul de la matrice tangente par perturbation
500     continue
!
        if (defo_comp(1:5) .eq. 'PETIT') then
            if (defo_comp(6:10) .eq. '_REAC') then
                do i = 1, ndim*nno
                    zr(igeom+i-1) = zr(igeom+i-1) + zr(ideplm+i-1) + zr(ideplp+i-1)
                end do
            endif
            call nmpl3d(fami        , nno      , npg       ,&
                        ipoids      , ivf      , idfde     ,&
                        zr(igeom)   , typmod   , option    , zi(imate),&
                        zk16(icompo), mult_comp, lgpg      , zr(icarcr),&
                        zr(iinstm)  , zr(iinstp),&
                        zr(ideplm)  , zr(ideplp),&
                        angl_naut   , zr(icontm), zr(ivarim),&
                        matsym      , zr(icontp), zr(ivarip),&
                        zr(imatuu)  , zr(ivectu), codret)
        else if (defo_comp .eq. 'SIMO_MIEHE') then
            call nmgpfi(fami      , option      , typmod    , ndim      , nno       ,&
                        npg       , ipoids      , zr(ivf)   , idfde     , zr(igeom) ,&
                        dfdi      , zk16(icompo), zi(imate) , mult_comp , lgpg      , zr(icarcr),&
                        angl_naut , zr(iinstm)  , zr(iinstp), zr(ideplm), zr(ideplp),&
                        zr(icontm), zr(ivarim)  , zr(icontp), zr(ivarip), zr(ivectu),&
                        zr(imatuu), codret)
        else if (defo_comp .eq. 'GROT_GDEP') then
            call nmgr3d(option      , typmod    ,&
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
            call nmdlog(fami      , option    , typmod      , ndim      , nno       ,&
                        npg       , ipoids    , ivf         , zr(ivf)   , idfde     ,&
                        zr(igeom) , dfdi      , zk16(icompo), mult_comp , zi(imate) , lgpg,&
                        zr(icarcr), angl_naut , zr(iinstm)  , zr(iinstp), matsym    ,&
                        zr(ideplm), zr(ideplp), zr(icontm)  , zr(ivarim), zr(icontp),&
                        zr(ivarip), zr(ivectu), zr(imatuu)  , codret)
        else
            ASSERT(ASTER_FALSE)
        endif
        if (codret .ne. 0) then
            goto 999
        endif
! ----- Calcul eventuel de la matrice TGTE par PERTURBATION
        call tgveri(option, zr(icarcr), zk16(icompo), nno, zr(igeom),&
                    ndim, ndim*nno, zr(ideplp), sdepl, zr(ivectu),&
                    svect, sz_tens*npg, zr(icontp), scont, npg*lgpg,&
                    zr(ivarip), zr(ivarix), zr(imatuu), smatr, matsym,&
                    epsilo, varia, iret)
        if (iret .ne. 0) then
            goto 500
        endif
!
    endif
!
999 continue
!
! - Save return code
!
    if (lSigm) then
        call jevech('PCODRET', 'E', jv_codret)
        zi(jv_codret) = codret
    endif
!
end subroutine
