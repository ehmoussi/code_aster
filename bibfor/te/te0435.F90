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
subroutine te0435(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/codere.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/jevecd.h"
#include "asterfort/mbxnlr.h"
#include "asterfort/mbgnlr.h"
#include "asterfort/mbcine.h"
#include "asterfort/mbrigi.h"
#include "asterfort/nmprmb_matr.h"
#include "asterfort/r8inir.h"
#include "asterc/r8prem.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/verift.h"
#include "blas/dcopy.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: GRILLE_MEMBRANE / GRILLE_EXCENTRE
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!          RIGI_MECA
!          RIGI_MECA_PRSU_R
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    character(len=4) :: fami
    integer :: nddl, nno, nnos, npg, ndim, ncomp, nvari
    integer :: n, kpg, iret, cod(9)
    integer :: ipoids, ivf, idfde, jgano, jtab(7)
    integer :: igeom, icacoq, imate, icompo, icarcr
    integer :: iinstm, iinstp, icontm, ideplm, ideplp, ivarim, ivarix
    integer :: ivectu, icontp, ivarip, jcret, imatuu, imatun, icontx, i_pres
    real(kind=8) :: dff(2, 9), alpha, beta, h, preten
    aster_logical :: lNonLine, lLine
    aster_logical :: pttdef, grddef
    aster_logical :: lVect, lMatr, lVari, lSigm
    character(len=16) :: defo_comp, rela_comp
!
! --------------------------------------------------------------------------------------------------
!
    lNonLine = (option(1:9).eq.'FULL_MECA').or.&
               (option.eq.'RAPH_MECA').or.&
               (option(1:10).eq.'RIGI_MECA_') .and. option .ne. 'RIGI_MECA_PRSU_R'
    lLine    = option .eq. 'RIGI_MECA'
    cod      = 0
!
! - NOMBRE DE COMPOSANTES DES TENSEURS
!
    ncomp = 3
    nddl = 3
!
! - FONCTIONS DE FORME ET POINTS DE GAUSS
!
    fami = 'RIGI'
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
! - Get input fields
!
    lVect = ASTER_FALSE
    lVari = ASTER_FALSE
    lSigm = ASTER_FALSE
    lMatr = ASTER_FALSE
    call jevech('PGEOMER', 'L', igeom)
    if (option .ne. 'RIGI_MECA_PRSU_R') then
        call jevech('PCACOQU', 'L', icacoq)
        call jevech('PMATERC', 'L', imate)
    endif
    if (lNonLine) then
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCARCRI', 'L', icarcr)
        call jevech('PINSTMR', 'L', iinstm)
        call jevech('PINSTPR', 'L', iinstp)
        call jevech('PCONTMR', 'L', icontm)
        call tecach('OOO', 'PVARIMR', 'L', iret, nval=7,&
                    itab=jtab)
        nvari = max(jtab(6),1)*jtab(7)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PVARIMP', 'L', ivarix)
    endif
    if (option .ne. 'RIGI_MECA') then
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
    endif
!
    if (lNonLine) then
! ----- Select objects to construct from option name
        call behaviourOption(option, zk16(icompo),&
                             lMatr , lVect ,&
                             lVari , lSigm)
! ----- Properties of behaviour
        rela_comp = zk16(icompo-1+RELA_NAME)
        defo_comp = zk16(icompo-1+DEFO)
        pttdef = (defo_comp.eq.'PETIT')
        grddef = (defo_comp.eq.'GROT_GDEP')
        if (.not.pttdef .and. .not. grddef) then
            call utmess('F', 'MEMBRANE_2', sk=defo_comp)
        endif
    endif
    if (lLine) then
        pttdef = ASTER_TRUE
        grddef = ASTER_FALSE
        lMatr  = ASTER_TRUE
    endif

! - PARAMETRES NECESSAIRE AU CALCUL DE LA MATRICE DE RIGITE POUR PRESSION SUIVEUSE
    if (option.eq.'RIGI_MECA_PRSU_R') then
        call jevecd('PPRESSR', i_pres, 0.d0)
    endif
!
! - Get output fields
!
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
        call jevech('PCODRET', 'E', jcret)
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
        call dcopy(npg*nvari, zr(ivarix), 1, zr(ivarip), 1)
    endif
    if (lMatr) then
        call jevech('PMATUUR', 'E', imatuu)
    endif
    if (option .eq. 'RIGI_MECA_PRSU_R') then
        call jevech('PMATUNS', 'E', imatun)
    endif
    if (option .eq. 'RIGI_MECA_IMPLEX') then
        call jevech('PCONTXR', 'E', icontx)
        call dcopy(npg*ncomp, zr(icontm), 1, zr(icontx), 1)
    endif
!
!
! -----------------------------------------------------------------
! ---          IMPORTATION DES PARAMETRES MATERIAU              ---
! -----------------------------------------------------------------
!
! - DIRECTION DE REFERENCE POUR UN COMPORTEMENT ANISOTROPE
! - EPAISSEUR
! - PRECONTRAINTES
!
    if (option .ne. 'RIGI_MECA_PRSU_R') then
        alpha = zr(icacoq+1) * r8dgrd()
        beta = zr(icacoq+2) * r8dgrd()
        h = zr(icacoq)
! ---   On empeche une epaisseur nulle ou negative
        if ( h .lt. r8prem() ) then
            call utmess('F', 'MEMBRANE_1')
        endif
        preten = zr(icacoq+3)/h
    endif
!
    do kpg = 1, npg
        do n = 1, nno
            dff(1,n)=zr(idfde+(kpg-1)*nno*2+(n-1)*2)
            dff(2,n)=zr(idfde+(kpg-1)*nno*2+(n-1)*2+1)
        end do
        if (option .eq. 'RIGI_MECA_PRSU_R') then
            call nmprmb_matr(nno, npg, kpg, zr(ipoids+kpg), zr(ivf), dff,&
                             igeom,ideplm,ideplp,i_pres, imatun)
        else
            if (pttdef) then
                call mbxnlr(option, fami  ,&
                            nddl  , nno   , ncomp , kpg   ,&
                            ipoids, igeom , imate , ideplm,&
                            ideplp, ivectu, icontp, imatuu,&
                            dff   , alpha , beta  ,&
                            lVect , lMatr)
            elseif (grddef) then
                if (rela_comp(1:14 ) .eq. 'ELAS_MEMBRANE_') then
                    if ((abs(alpha).gt.r8prem()) .or. (abs(beta).gt.r8prem())) then
                        call utmess('A', 'MEMBRANE_6')
                    endif
                    call mbgnlr(option, lVect , lMatr ,&
                                nno   , ncomp , imate , icompo,&
                                dff   , alpha , beta  , h     ,&
                                preten, igeom , ideplm, ideplp,&
                                kpg   , fami  , ipoids, icontp,&
                                ivectu, imatuu)
                else
                    call utmess('F', 'MEMBRANE_3')
                endif
            endif
        endif
    end do
!
    if (lSigm) then
        call codere(cod, npg, zi(jcret))
    endif
!
end subroutine
