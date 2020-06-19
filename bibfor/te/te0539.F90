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
! person_in_charge: samuel.geniaut at edf.fr
!
subroutine te0539(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/ltequa.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmtstm.h"
#include "asterfort/rcangm.h"
#include "asterfort/teattr.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/xnmel.h"
#include "asterfort/xnmgr.h"
#include "asterfort/xnmpl.h"
#include "asterfort/xteddl.h"
#include "asterfort/xteini.h"
#include "asterfort/Behaviour_type.h"
#include "blas/dcopy.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: XFEM
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!          RIGI_MECA (linear)
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: typmod(2), enr, lag
    character(len=16) :: compor(4), elref
    integer :: jgano, nno, npg, i, imatuu, lgpg, ndim, iret, nfiss
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: icontm, ivarim
    integer :: iinstm, iinstp, ideplm, ideplp, icompo, icarcr
    integer :: ivectu, icontp, ivarip, li, jcret, codret
    integer :: ivarix
    integer :: jpintt, jcnset, jheavt, jlonch, jbaslo, jlsn, jlst, jstno, jpmilt, jheavn
    integer :: jtab(7), nnos, idim, jfisno
    integer :: nfh, ddlc, nddl, nnom, nfe, ibid, ddls, ddlm
    aster_logical :: matsym, l_nonlin, l_line 
    real(kind=8) :: angmas(7), bary(3), crit(1), sig(1), vi(1)
    character(len=16) :: defo_comp, rela_comp, type_comp
    aster_logical :: lVect, lMatr, lVari, lSigm, lMatrPred
!
! --------------------------------------------------------------------------------------------------
!
    icontp = 1
    ivarip = 1
    imatuu = 1
    ivectu = 1
    ivarix = 1
    codret = 0
!
! - Get element parameters
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    call elref1(elref)
    ASSERT(nno .le. 27)
!
!     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
    call xteini(nomte, nfh, nfe, ibid, ddlc,&
                nnom, ddls, nddl, ddlm, nfiss,&
                ibid)
!
! - Type of finite element
!
    if (ndim .eq. 3) then
        typmod(1) = '3D'
        typmod(2) = ' '
    else
        if (lteatt('AXIS','OUI')) then
            typmod(1) = 'AXIS'
        else if (lteatt('C_PLAN','OUI')) then
            typmod(1) = 'C_PLAN'
        else if (lteatt('D_PLAN','OUI')) then
            typmod(1) = 'D_PLAN'
        else
            ASSERT(lteatt('C_PLAN', 'OUI'))
        endif
        typmod(2) = ' '
    endif
!
! - General options
!
    l_nonlin = (option(1:9).eq.'FULL_MECA').or.&
               (option.eq.'RAPH_MECA').or.&
               (option(1:10).eq.'RIGI_MECA_')
    l_line   = option .eq. 'RIGI_MECA'
    ASSERT(l_nonlin .or. l_line)
    lVect = ASTER_FALSE
    lMatr = ASTER_FALSE
    lVari = ASTER_FALSE
    lSigm = ASTER_FALSE
    if (l_line) then
        lMatr = ASTER_TRUE
    endif
    lMatrPred = option(1:9) .eq. 'RIGI_MECA'
!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
!
    if (l_nonlin) then
        ASSERT(.not. l_line)
        call jevech('PINSTMR', 'L', iinstm)
        call jevech('PINSTPR', 'L', iinstp)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCARCRI', 'L', icarcr)
        call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
        lgpg = max(jtab(6),1)*jtab(7)
        npg  = jtab(2)
    endif
!
! - Get input fields for XFEM
!
    call jevech('PPINTTO', 'L', jpintt)
    call jevech('PCNSETO', 'L', jcnset)
    call jevech('PHEAVTO', 'L', jheavt)
    call jevech('PLONCHA', 'L', jlonch)
    call jevech('PBASLOR', 'L', jbaslo)
    call jevech('PLSN', 'L', jlsn)
    call jevech('PLST', 'L', jlst)
    call jevech('PSTANO', 'L', jstno)
    call teattr('S', 'XFEM', enr, ibid)
    if (enr(1:2).eq. 'XH') then
        call jevech('PHEA_NO', 'L', jheavn)
    endif
    if ((ibid.eq.0) .and. ltequa(elref,enr)) then
        call jevech('PPMILTO', 'L', jpmilt)
    endif
    if (nfiss .gt. 1) then
        call jevech('PFISNO', 'L', jfisno)
    endif
!
! - Rigidity matrix (linear)
!
    if (l_line) then
        call jevech('PMATUUR', 'E', imatuu)
        lgpg   = 0
        compor = ' '
        call xnmel('+', nno, nfh, nfe, ddlc,&
                   ddlm, igeom, typmod, option, zi( imate),&
                   compor, lgpg, crit, jpintt, zi(jcnset),&
                   zi(jheavt), zi( jlonch), zr(jbaslo), ibid, zr(jlsn),&
                   zr(jlst), sig, vi, zr(imatuu), ibid,&
                   codret, jpmilt, nfiss, jheavn, jstno,&
                   l_line, l_nonlin, lMatr, lVect, lSigm)
        matsym = .true.
        goto 999
    endif
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
    call rcangm(ndim, bary, angmas)
!
! - Select objects to construct from option name (non-linear case)
!
    call behaviourOption(option, zk16(icompo),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! - Properties of behaviour
!
    rela_comp = zk16(icompo-1+RELA_NAME)
    defo_comp = zk16(icompo-1+DEFO)
    type_comp = zk16(icompo-1+INCRELAS)
    if ((rela_comp.eq. 'ELAS') .and. (defo_comp.eq.'GROT_GDEP')) then
        type_comp = 'COMP_INCR'
        zk16(icompo-1+INCRELAS) = type_comp
    endif
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
!
! - HYPER-ELASTICITE
!
    if (type_comp .eq. 'COMP_ELAS') then
        if (lMatrPred) then
            call xnmel('-', nno, nfh, nfe, ddlc,&
                       ddlm, igeom, typmod, option, zi(imate),&
                       zk16(icompo), lgpg, zr(icarcr), jpintt, zi(jcnset),&
                       zi(jheavt), zi(jlonch), zr(jbaslo), ideplm, zr(jlsn),&
                       zr(jlst), zr(icontm), zr(ivarim), zr(imatuu), ivectu,&
                       codret, jpmilt, nfiss, jheavn, jstno,&
                       l_line, l_nonlin, lMatr, lVect, lSigm)
        else
            do li = 1, nddl
                zr(ideplp+li-1) = zr(ideplm+li-1) + zr(ideplp+li-1)
            end do
            call xnmel('+', nno, nfh, nfe, ddlc,&
                       ddlm, igeom, typmod, option, zi(imate),&
                       zk16(icompo), lgpg, zr(icarcr), jpintt, zi(jcnset),&
                       zi(jheavt), zi(jlonch), zr(jbaslo), ideplp, zr(jlsn),&
                       zr(jlst), zr(icontp), zr(ivarip), zr(imatuu), ivectu,&
                       codret, jpmilt, nfiss, jheavn, jstno,&
                       l_line, l_nonlin, lMatr, lVect, lSigm)
        endif
    else
!
! - HYPO-ELASTICITE
!
        if (defo_comp(1:5) .eq. 'PETIT') then
            if (defo_comp(6:10) .eq. '_REAC') then
                call utmess('F', 'XFEM_50')
            endif
            call xnmpl(nno, nfh, nfe, ddlc, ddlm,&
                       igeom, zr(iinstm), zr( iinstp), ideplp, zr(icontm),&
                       zr(ivarip), typmod, option, zi( imate), zk16(icompo),&
                       lgpg, zr(icarcr), jpintt, zi(jcnset), zi(jheavt),&
                       zi(jlonch), zr(jbaslo), ideplm, zr(jlsn), zr(jlst),&
                       zr(icontp), zr(ivarim), zr(imatuu), ivectu, codret,&
                       jpmilt, nfiss, jheavn, jstno,&
                       lMatr, lVect, lSigm)
        else if (defo_comp .eq. 'GROT_GDEP') then
            do i = 1, nddl
                zr(ideplp+i-1) = zr(ideplm+i-1) + zr(ideplp+i-1)
            end do
            call xnmgr(nno, nfh, nfe, ddlc, ddlm,&
                       igeom, zr(iinstm), zr( iinstp), ideplp, zr(icontm),&
                       zr(ivarip), typmod, option, zi( imate), zk16(icompo),&
                       lgpg, zr(icarcr), jpintt, zi(jcnset), zi(jheavt),&
                       zi(jlonch), zr(jbaslo), ideplm, zr(jlsn), zr(jlst),&
                       nfiss, jheavn, zr(icontp), zr(ivarim), zr(imatuu),&
                       ivectu, codret, jpmilt, jstno,&
                       lMatr, lVect, lSigm)
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
!
999 continue
!
!     SUPPRESSION DES DDLS SUPERFLUS
    call teattr('C', 'XLAG', lag, ibid)
    if (ibid .eq. 0 .and. lag .eq. 'ARETE') then
        nno = nnos
    endif

!   OPTIONS RELATIVES A UNE MATRICE UNIQUEMENT
    if (option .eq. 'RIGI_MECA' ) then
        call xteddl(ndim, nfh, nfe, ddls, nddl,&
                    nno, nnos, zi(jstno), .false._1, matsym,&
                    option, nomte, ddlm, nfiss, jfisno,&
                    mat=zr(imatuu))
!   OPTIONS RELATIVES A UN VECTEUR UNIQUEMENT
    else if (option .eq. 'RAPH_MECA') then
        call xteddl(ndim, nfh, nfe, ddls, nddl,&
                    nno, nnos, zi(jstno), .false._1, matsym,&
                    option, nomte, ddlm, nfiss, jfisno,&
                    vect=zr(ivectu))
!   OPTIONS RELATIVES A UNE MATRICE ET UN VECTEUR
    else if (option .eq. 'FULL_MECA'.or. option .eq. 'RIGI_MECA_TANG') then
        call xteddl(ndim, nfh, nfe, ddls, nddl,&
                    nno, nnos, zi(jstno), .false._1, matsym,&
                    option, nomte, ddlm, nfiss, jfisno,&
                    mat=zr(imatuu), vect=zr(ivectu))
    else
        ASSERT(.false.)
    endif
!
! - Save return code
!
    if (lSigm) then
        call jevech('PCODRET', 'E', jcret)
        zi(jcret) = codret
    endif
!
end subroutine
