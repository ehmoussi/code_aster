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
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
subroutine te0364(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/mmelem.h"
#include "asterfort/mmlagc.h"
#include "asterfort/mmGetAlgo.h"
#include "asterfort/mmGetCoefficients.h"
#include "asterfort/mmGetProjection.h"
#include "asterfort/mmGetStatus.h"
#include "asterfort/mmGetShapeFunctions.h"
#include "asterfort/mmmpha.h"
#include "asterfort/mmmsta.h"
#include "asterfort/mmnsta.h"
#include "asterfort/mmtppe.h"
#include "asterfort/mngliss.h"
#include "asterfort/mmmtdb.h"
#include "asterfort/mmCombLineMatr.h"
#include "asterfort/mmCompMatrCont.h"
#include "asterfort/mmCompMatrFric.h"
#include "Contact_type.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Options: RIGI_CONT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, ij, jv_matr
    integer :: nne, nnm, nnl
    integer :: nddl, ndim, nbcps, nbdm
    integer :: i_reso_fric, i_reso_geom, ialgoc, ialgof
    integer :: ndexfr
    integer :: indco, indco_prev, indadhe_prev, indadhe2_prev
    character(len=8) :: typmae, typmam
    character(len=4) :: phase, phase_prev
    aster_logical :: laxis, leltf
    aster_logical :: lpenac, lpenaf
    aster_logical :: lcont, ladhe , l_fric_no
    aster_logical :: l_prev_cont, l_prev_fric
    aster_logical :: l_previous
    aster_logical :: debug, l_large_slip
    aster_logical :: lcont_prev, ladhe_prev , l_fric_no_p
    real(kind=8) :: coefff
    real(kind=8) :: lambda , lambds
    real(kind=8) :: lambda_prev  , lambds_prev
    real(kind=8) :: coefac , coefaf
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: wpg_prev, jacobi_prev
    real(kind=8) :: norm(3) , tau1(3) , tau2(3)
    real(kind=8) :: jeusup
    real(kind=8) :: dlagrc, dlagrf(2)
    real(kind=8) :: jeu, djeut(3)
    real(kind=8) :: rese(3), nrese
    real(kind=8) :: mprojt(3, 3)
    real(kind=8) :: mprt1n(3, 3), mprt2n(3, 3)
    real(kind=8) :: mprnt1(3, 3), mprnt2(3, 3)
    real(kind=8) :: mprt11(3, 3), mprt12(3, 3)
    real(kind=8) :: mprt21(3, 3), mprt22(3, 3)
    real(kind=8) :: kappa(2, 2)
    real(kind=8) :: mprojn(3, 3), h(2, 2)
    real(kind=8) :: vech1(3), vech2(3)
    real(kind=8) :: ffe(9), ffm(9), ffl(9), dffm(2, 9),ddffm(3, 9)
    real(kind=8) :: ffe_prev(9), ffm_prev(9), ffl_prev(9)
    real(kind=8) :: dffm_prev(2, 9),ddffm_prev(3, 9)
    real(kind=8) :: alpha_cont
    real(kind=8) :: dnepmait1, dnepmait2, taujeu1, taujeu2
    real(kind=8) :: xpc, ypc, xpr, ypr
    real(kind=8) :: xpc_prev, ypc_prev, xpr_prev, ypr_prev
    real(kind=8) :: mprojn_prev(3, 3), mprojt_prev(3, 3)
    real(kind=8) :: norm_prev(3)  , tau1_prev(3)  , tau2_prev(3)
    real(kind=8) :: coefac_prev , coefaf_prev
    real(kind=8) :: rese_prev(3), nrese_prev
    real(kind=8) :: dlagrc_prev, dlagrf_prev(2)
    real(kind=8) :: hah(2,2), hah_prev(2,2)
    real(kind=8) :: jeu_prev, djeut_prev(3)
    real(kind=8) :: dnepmait1_prev, dnepmait2_prev, taujeu1_prev, taujeu2_prev
    real(kind=8) :: mprt1n_prev(3, 3), mprt2n_prev(3, 3)
    real(kind=8) :: mprnt1_prev(3, 3), mprnt2_prev(3, 3)
    real(kind=8) :: mprt11_prev(3, 3), mprt12_prev(3, 3)
    real(kind=8) :: mprt21_prev(3, 3), mprt22_prev(3, 3)
    real(kind=8) :: kappa_prev(2, 2), h_prev(2, 2)
    real(kind=8) :: vech1_prev(3), vech2_prev(3)
    real(kind=8) :: matr_cont(81, 81), matr_conp(81, 81)
    real(kind=8) :: matr_fric(81, 81), matr_frip(81, 81)
!
! --------------------------------------------------------------------------------------------------
!
    debug = ASTER_FALSE
    matr_cont(:,:) = 0.d0
    matr_conp(:,:) = 0.d0
    matr_fric(:,:) = 0.d0
    matr_frip(:,:) = 0.d0
    laxis = ASTER_FALSE
    leltf = ASTER_FALSE
    lpenac = ASTER_FALSE
    lpenaf = ASTER_FALSE
    lcont = ASTER_FALSE
    ladhe = ASTER_FALSE
    l_fric_no = ASTER_FALSE
    l_prev_cont = ASTER_FALSE
    l_prev_fric = ASTER_FALSE
    l_previous = ASTER_FALSE
    debug = ASTER_FALSE
    l_large_slip = ASTER_FALSE
    lcont_prev = ASTER_FALSE
    ladhe_prev = ASTER_FALSE
    l_fric_no_p = ASTER_FALSE
    coefff = 0.d0
    lambda = 0.d0
    lambds = 0.d0
    lambda_prev = 0.d0
    lambds_prev  = 0.d0
    coefac = 0.d0
    coefaf = 0.d0
    wpg = 0.d0
    jacobi = 0.d0
    wpg_prev = 0.d0
    jacobi_prev = 0.d0
    norm(:) = 0.d0
    tau1(:) = 0.d0
    tau2(:) = 0.d0
    jeusup = 0.d0
    dlagrc = 0.d0
    dlagrf(:) = 0.d0
    jeu = 0.d0
    djeut(:) = 0.d0
    rese(:) = 0.d0
    nrese = 0.d0
    mprojt(:, :) = 0.d0
    mprt1n(:, :) = 0.d0
    mprt2n(:, :) = 0.d0
    mprnt1(:, :) = 0.d0
    mprnt2(:, :) = 0.d0
    mprt11(:, :) = 0.d0
    mprt12(:, :) = 0.d0
    mprt21(:, :) = 0.d0
    mprt22(:, :) = 0.d0
    kappa(:, :) = 0.d0
    mprojn(:, :) = 0.d0
    h(:, :) = 0.d0
    vech1(:) = 0.d0
    vech2(:) = 0.d0
    ffe(:) = 0.d0
    ffm(:) = 0.d0
    ffl(:) = 0.d0
    dffm(:, :) = 0.d0
    ddffm(:, :) = 0.d0
    ffe_prev(:) = 0.d0
    ffm_prev(:) = 0.d0
    ffl_prev(:) = 0.d0
    dffm_prev(:, :) = 0.d0
    ddffm_prev(:, :) = 0.d0
    mprojn_prev(:, :) = 0.d0
    mprojt_prev(:, :) = 0.d0
    norm_prev(:) = 0.d0
    tau1_prev(:) = 0.d0
    tau2_prev(:) = 0.d0
    coefac_prev = 0.d0
    coefaf_prev = 0.d0
    rese_prev(:) = 0.d0
    nrese_prev = 0.d0
    dlagrc_prev = 0.d0
    dlagrf_prev(:) = 0.d0
    hah(:,:) = 0.d0
    hah_prev(:,:) = 0.d0
    jeu_prev = 0.d0
    djeut_prev(:) = 0.d0
    mprt1n_prev(:, :) = 0.d0
    mprt2n_prev(:, :) = 0.d0
    mprnt1_prev(:, :) = 0.d0
    mprnt2_prev(:, :) = 0.d0
    mprt11_prev(:, :) = 0.d0
    mprt12_prev(:, :) = 0.d0
    mprt21_prev(:, :) = 0.d0
    mprt22_prev(:, :) = 0.d0
    kappa_prev(:, :) = 0.d0
    h_prev(:,:) = 0.d0
    vech1_prev(:) = 0.d0
    vech2_prev(:) = 0.d0
!
! - Get informations on cell (slave and master)
!
    call mmelem(nomte , ndim , nddl,&
                typmae, nne  ,&
                typmam, nnm  ,&
                nnl   , nbcps, nbdm,&
                laxis , leltf)
!
! - Get status
!
    call mmGetStatus(indco      ,&
                     l_prev_cont, l_prev_fric ,&
                     indco_prev , indadhe_prev, indadhe2_prev)
    l_previous = l_prev_cont .or. l_prev_fric
!
! - Get coefficients
!
    call mmGetCoefficients(coefff, coefac, coefaf, alpha_cont)
    if (l_prev_cont) then
        coefac_prev = coefac
    endif
    if (l_prev_fric) then
        coefac_prev = coefac
        coefaf_prev = coefaf
    endif
!
! - Get projections datas
!
    call mmGetProjection(i_reso_geom, wpg     ,&
                         xpc        , ypc     , xpr     , ypr     , tau1     , tau2     ,&
                         xpc_prev   , ypc_prev, xpr_prev, ypr_prev, tau1_prev, tau2_prev,wpg_prev)
!
! - Get algorithms
!
    call mmGetAlgo(l_large_slip, ndexfr  , jeusup, lambds,&
                   ialgoc      , ialgof  , i_reso_fric, i_reso_geom,&
                   lpenac      , lpenaf  ,&
                   lambds_prev , jeu_prev)
!
! - Get shape functions
!
    call mmGetShapeFunctions(laxis, typmae, typmam, &
                             ndim , nne   , nnm   , &
                             xpc  , ypc   , xpr   , ypr  ,&
                             ffe  , ffm   , dffm  , ddffm,&
                             ffl  , jacobi)

    if (l_prev_cont .or. l_prev_fric) then
        call mmGetShapeFunctions(laxis   , typmae  , typmam   , &
                                 ndim    , nne     , nnm      , &
                                 xpc_prev, ypc_prev, xpr_prev , ypr_prev  ,&
                                 ffe_prev, ffm_prev, dffm_prev, ddffm_prev,&
                                 ffl_prev, jacobi_prev)
    endif
!
! - Compute quantities
!
    call mmtppe(ndim       , nne      , nnm   , nnl     , nbdm  ,&
                i_reso_geom, l_large_slip, &
                jeusup   ,&
                tau1     , tau2     ,&
                ffe      , ffm      , dffm  , ddffm   , ffl   ,&
                jeu      , djeut ,&
                dlagrc   , dlagrf   , &
                norm     , mprojn   , mprojt,&
                mprt1n   , mprt2n   , mprnt1, mprnt2, &
                mprt11   , mprt12   , mprt21, mprt22,&
                kappa    , h        , hah,&
                vech1    , vech2    ,&
                taujeu1  , taujeu2  ,&
                dnepmait1, dnepmait2)
    if (l_prev_cont .or. l_prev_fric) then
        call mmtppe(ndim          , nne      , nnm     , nnl     , nbdm  ,&
                    i_reso_geom, l_large_slip, &
                    jeusup   ,&
                    tau1_prev     , tau2_prev,&
                    ffe_prev      , ffm_prev      , dffm_prev    , ddffm_prev   , ffl_prev   ,&
                    jeu_prev , djeut_prev,&
                    dlagrc_prev   , dlagrf_prev,&
                    norm_prev     , mprojn_prev, mprojt_prev,&
                    mprt1n_prev   , mprt2n_prev, mprnt1_prev, mprnt2_prev,&
                    mprt11_prev   , mprt12_prev, mprt21_prev, mprt22_prev,&
                    kappa_prev    , h_prev        , hah_prev   ,&
                    vech1_prev    , vech2_prev    ,&
                    taujeu1_prev  , taujeu2_prev  ,&
                    dnepmait1_prev, dnepmait2_prev)
    endif
!
! - Get contact pressure
!
    call mmlagc(lambds, dlagrc, i_reso_fric, lambda)
    if (l_prev_cont .or. l_prev_fric) then
        call mmlagc(lambds_prev, dlagrc_prev, i_reso_fric, lambda_prev)
    endif
!
! - Compute state of contact and friction
!
    call mmmsta(ndim  , leltf , indco,&
                ialgoc, ialgof,&
                lpenaf, coefaf,&
                lambda, djeut , dlagrf,&
                tau1  , tau2  ,&
                lcont , ladhe , l_fric_no,&
                rese  , nrese )
    if (l_prev_cont .or. l_prev_fric) then
        call mmmsta(ndim        , leltf        , indco,&
                    ialgoc      , ialgof       ,&
                    lpenaf      , coefaf       ,&
                    lambda_prev , djeut_prev   , dlagrf_prev,&
                    tau1_prev   , tau2_prev    ,&
                    lcont_prev  , ladhe_prev   , l_fric_no_p,&
                    rese_prev   , nrese_prev   ,&
                    l_previous  , indco_prev   ,&
                    indadhe_prev, indadhe2_prev)
    endif
!
! - Select phase to compute
!
    call mmmpha(leltf, lcont, ladhe, l_fric_no, phase)
    if (l_prev_cont .or. l_prev_fric) then
        call mmmpha(leltf, lcont_prev, ladhe_prev, l_fric_no_p, phase_prev)
    endif
!
! - Large sliding hypothesis
!
    if (lcont .and.  (phase .eq. 'GLIS') .and. (l_large_slip) .and. (abs(jeu) .lt. 1.d-6 )) then
        call mngliss(ndim     , kappa    ,&
                     tau1     , tau2     ,&
                     taujeu1  , taujeu2  ,&
                     dnepmait1, dnepmait2,&
                     djeut )
        call mmnsta(ndim  , leltf ,&
                    lpenaf, coefaf,&
                    indco ,&
                    lambda, djeut , dlagrf,&
                    tau1  , tau2  ,&
                    lcont , ladhe ,&
                    rese  , nrese)
    endif
!
! - Compute matrices for contact
!
    call mmCompMatrCont(phase    , lpenac, i_reso_geom, &
                        nbdm     , &
                        ndim     , nne   , nnm   , nnl,&
                        wpg      , jacobi, coefac,&
                        jeu      , dlagrc,&
                        ffe      , ffm   , ffl   , dffm  ,&
                        norm     , mprojn,&
                        mprt1n   , mprt2n, mprnt1, mprnt2,&
                        mprt11   , mprt12, mprt21, mprt22,&
                        kappa    , vech1 , vech2 ,&
                        h        , hah   , &
                        matr_cont)
    if (l_prev_cont) then
        call mmCompMatrCont(phase_prev , lpenac     , i_reso_geom, &
                            nbdm       , &
                            ndim       , nne        , nnm        , nnl,&
                            wpg_prev        , jacobi_prev     , coefac_prev,&
                            jeu_prev   , dlagrc_prev,&
                            ffe_prev        , ffm_prev        , ffl_prev        , dffm_prev    ,&
                            norm_prev       , mprojn_prev,&
                            mprt1n_prev, mprt2n_prev, mprnt1_prev, mprnt2_prev,&
                            mprt11_prev, mprt12_prev, mprt21_prev, mprt22_prev,&
                            kappa_prev , vech1_prev , vech2_prev ,&
                            h_prev     , hah_prev   , &
                            matr_conp)
    endif
!
! - Compute matrices for friction
!
    if (leltf) then
        call mmCompMatrFric(phase      , l_large_slip,&
                            lpenaf     ,&
                            i_reso_geom     , i_reso_fric      ,&
                            nbdm       , nbcps       , ndexfr,&
                            ndim       , nne         , nnm   , nnl   ,&
                            wpg        , jacobi      , coefac, coefaf,&
                            jeu        , dlagrc      ,&
                            ffe        , ffm         , ffl   , dffm  , ddffm,&
                            tau1       , tau2        , mprojt,&
                            rese       , nrese       , lambda, coefff,&
                            mprt1n     , mprt2n      , mprnt1, mprnt2,&
                            mprt11     , mprt12      , mprt21, mprt22,&
                            kappa      , vech1       , vech2 ,&
                            h          , &
                            dlagrf     , djeut ,&
                            matr_fric)
        if (l_prev_fric) then
            call mmCompMatrFric(phase_prev , l_large_slip,&
                                lpenaf     ,&
                                i_reso_geom     , i_reso_fric      ,&
                                nbdm       , nbcps       , ndexfr,&
                                ndim       , nne         , nnm   , nnl   ,&
                                wpg_prev        , jacobi_prev      , coefac_prev, coefaf_prev,&
                                jeu_prev   , dlagrc_prev,&
                                ffe_prev        , ffm_prev         , ffl_prev   , dffm_prev  , &
                                ddffm_prev,&
                                tau1_prev  , tau2_prev        , mprojt_prev,&
                                rese_prev  , nrese_prev  , lambda_prev, coefff,&
                                mprt1n_prev, mprt2n_prev , mprnt1_prev, mprnt2_prev,&
                                mprt11_prev, mprt12_prev , mprt21_prev, mprt22_prev,&
                                kappa_prev , vech1_prev  , vech2_prev,&
                                h_prev     , &
                                dlagrf_prev, djeut_prev,&
                                matr_frip)
        endif
    endif
!
! - Linear combination of matrix
!
    if (l_prev_cont) then
        call mmCombLineMatr(alpha_cont, matr_conp, matr_cont)
    endif
    if (l_prev_fric) then
        call mmCombLineMatr(alpha_cont, matr_frip, matr_fric)
    endif
!
! - Copy
!
    if ((lpenac.and.(.not.leltf)) .or.&
        (leltf.and.(i_reso_fric.eq.ALGO_NEWT)) .or.&
        (lpenaf.and.leltf)) then
        call jevech('PMATUNS', 'E', jv_matr)
        do j = 1, nddl
            do i = 1, nddl
                ij = j+nddl*(i-1)
                zr(jv_matr+ij-1) = matr_cont(i,j) + matr_fric(i,j)
                if (debug) then
                    call mmmtdb( matr_cont(i,j) + matr_fric(i,j), 'IJ', i, j)
                endif
            enddo
        enddo
    else
        call jevech('PMATUUR', 'E', jv_matr)
        do j = 1, nddl
            do i = 1, j
                ij = (j-1)*j/2 + i
                zr(jv_matr+ij-1) = matr_cont(i,j) + matr_fric(i,j)
                if (debug) then
                    call mmmtdb( matr_cont(i,j) + matr_fric(i,j), 'IJ', i, j)
                endif
            end do
        end do
    endif
!
end subroutine
