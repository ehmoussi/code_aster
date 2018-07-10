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
#include "asterfort/mmmpha.h"
#include "asterfort/mmmsta.h"
#include "asterfort/mmnsta.h"
#include "asterfort/mngliss.h"
#include "asterfort/mmmtas.h"
#include "asterfort/mmmtdb.h"
#include "asterfort/mmmtex.h"
#include "asterfort/mmtape.h"
#include "asterfort/mmtfpe.h"
#include "asterfort/mmtgeo.h"
#include "asterfort/mmtppe.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Options: RIGI_CONT / RIGI_FROT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf
    integer :: i, j, ij, jmatt
    integer :: nne, nnm, nnl
    integer :: nddl, ndim, nbcps, nbdm
    integer :: iresof, iresog, ialgoc, ialgof
    integer :: count_consistency
    integer :: ndexfr
    character(len=8) :: typmae, typmam
    character(len=9) :: phasep
    character(len=9) :: phasep_prev
    aster_logical :: laxis = .false. , leltf = .false.
    aster_logical :: lpenac = .false. , lpenaf = .false.
    aster_logical :: loptf = .false. , ldyna = .false., lcont = .false., ladhe = .false.
    aster_logical :: l_previous = .false.
    aster_logical :: debug = .false.
    aster_logical :: lcont_prev = .false., ladhe_prev = .false.
    aster_logical :: l_large_slip=ASTER_FALSE
    aster_logical :: lpenac_prev, lpenaf_prev
    aster_logical :: l_previous_cont, l_previous_frot
    real(kind=8) :: coefff = 0.0
    real(kind=8) :: lambda = 0.0, lambds = 0.0
    real(kind=8) :: lambda_prev = 0.0 , lambds_prev =0.0
    real(kind=8) :: coefac = 0.0, coefaf = 0.0
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: norm(3) = 0.0, tau1(3) = 0.0, tau2(3) = 0.0
    real(kind=8) :: jeusup=0.0
    real(kind=8) :: dlagrc=0.0, dlagrf(2)=0.0
    real(kind=8) :: jeu=0.0, djeut(3)=0.0
    real(kind=8) :: rese(3)=0.0, nrese=0.0
    real(kind=8) :: mprojt(3, 3)=0.0
    real(kind=8) :: mprt1n(3, 3)=0.0, mprt2n(3, 3)=0.0
    real(kind=8) :: mprnt1(3, 3)=0.0, mprnt2(3, 3)=0.0
    real(kind=8) :: mprt11(3, 3)=0.0, mprt12(3, 3)=0.0
    real(kind=8) :: mprt21(3, 3)=0.0, mprt22(3, 3)=0.0
    real(kind=8) :: kappa(2, 2)=0.0
    real(kind=8) :: mprojn(3, 3)=0.0, h(2, 2)=0.d0
    real(kind=8) :: vech1(3)=0.0, vech2(3)=0.0
    real(kind=8) :: ffe(9), ffm(9), ffl(9)
    real(kind=8) :: alpha_cont=0.0
    real(kind=8) :: dnepmait1, dnepmait2, taujeu1, taujeu2
    real(kind=8) :: xpc, ypc, xpr, ypr
    real(kind=8) :: xpc_prev, ypc_prev, xpr_prev, ypr_prev
    real(kind=8) :: mprojn_prev(3, 3)=0.0, mprojt_prev(3, 3)=0.0
    real(kind=8) :: norm_prev(3) = 0.0 , tau1_prev(3) = 0.0 , tau2_prev(3)=0.0
    real(kind=8) :: coefac_prev =0.0, coefaf_prev=0.0
    real(kind=8) :: rese_prev(3)=0.0, nrese_prev=0.0
    real(kind=8) :: dlagrc_prev=0.0, dlagrf_prev(2)=0.0
    real(kind=8) :: hah(2,2)=0.0, hah_prev(2,2)=0.0
    real(kind=8) :: jeu_prev=0.0, djeut_prev(3) = 0.0
    real(kind=8) :: dnepmait1_prev, dnepmait2_prev, taujeu1_prev, taujeu2_prev
    real(kind=8) :: ddffm(3, 9), dffm(2, 9)
    real(kind=8) :: mprt1n_prev(3, 3)=0.0, mprt2n_prev(3, 3)=0.0
    real(kind=8) :: mprnt1_prev(3, 3)=0.0, mprnt2_prev(3, 3)=0.0
    real(kind=8) :: mprt11_prev(3, 3)=0.0, mprt12_prev(3, 3)=0.0
    real(kind=8) :: mprt21_prev(3, 3)=0.0, mprt22_prev(3, 3)=0.0
    real(kind=8) :: kappa_prev(2, 2)=0., h_prev(2, 2)=0.0
    real(kind=8) :: vech1_prev(3)=0.0, vech2_prev(3)=0.0
    real(kind=8) :: jeusup_prev=0.0
!
    real(kind=8) :: mmat_tmp(81, 81)
    real(kind=8) :: mmat(81, 81)
    real(kind=8) :: mmat_prev(81, 81)
!
    real(kind=8) :: matrcc(9, 9)
    real(kind=8) :: matrcc_prev(9, 9)
!
    real(kind=8) :: matree(27, 27), matrmm(27, 27)
    real(kind=8) :: matree_prev(27, 27), matrmm_prev(27, 27)
    real(kind=8) :: matnee(27, 27), matnmm(27, 27)
    real(kind=8) :: matnee_prev(27, 27), matnmm_prev(27, 27)
    real(kind=8) :: matfee(27, 27), matfmm(27, 27)
    real(kind=8) :: matfee_prev(27, 27), matfmm_prev(27, 27)
!
    real(kind=8) :: matrem(27, 27), matrme(27, 27)
    real(kind=8) :: matrem_prev(27, 27), matrme_prev(27, 27)
    real(kind=8) :: matnem(27, 27), matnme(27, 27)
    real(kind=8) :: matnem_prev(27, 27), matnme_prev(27, 27)
    real(kind=8) :: matfem(27, 27), matfme(27, 27)
    real(kind=8) :: matfem_prev(27, 27), matfme_prev(27, 27)
!
    real(kind=8) :: matrce(9, 27), matrcm(9, 27)
    real(kind=8) :: matrce_prev(9, 27), matrcm_prev(9, 27)
    real(kind=8) :: matrmc(27, 9), matrec(27, 9)
    real(kind=8) :: matrmc_prev(27, 9), matrec_prev(27, 9)
    real(kind=8) :: matrff(18, 18)
    real(kind=8) :: matrff_prev(18, 18)
    real(kind=8) :: matrfe(18, 27), matrfm(18, 27)
    real(kind=8) :: matrfe_prev(18, 27), matrfm_prev(18, 27)
    real(kind=8) :: matrmf(27, 18), matref(27, 18)
    real(kind=8) :: matrmf_prev(27, 18), matref_prev(27, 18)
!
! --------------------------------------------------------------------------------------------------
!
    mmat(:,:) = 0.d0
    mmat_prev(:,:) = 0.d0
    mmat_tmp(:,:) = 0.d0
    matrcc(:,:) = 0.d0
    matrcc_prev(:,:) = 0.d0
    matree(:,:) = 0.d0
    matree_prev(:,:) = 0.d0
    matnee(:,:) = 0.d0
    matnee_prev(:,:) = 0.d0
    matfee(:,:) = 0.d0
    matfee_prev(:,:) = 0.d0
    matrmm(:,:) = 0.d0
    matrmm_prev(:,:) = 0.d0
    matnmm(:,:) = 0.d0
    matnmm_prev(:,:) = 0.d0
    matfmm(:,:) = 0.d0
    matfmm_prev(:,:) = 0.d0
    matrem(:,:) = 0.d0
    matrem_prev(:,:) = 0.d0
    matnem(:,:) = 0.d0
    matnem_prev(:,:) = 0.d0
    matfem(:,:) = 0.d0
    matfem_prev(:,:) = 0.d0
    matrme(:,:) = 0.d0
    matrme_prev(:,:) = 0.d0
    matnme(:,:) = 0.d0
    matnme_prev(:,:) = 0.d0
    matnme(:,:) = 0.d0
    matnme_prev(:,:) = 0.d0
    matfme(:,:) = 0.d0
    matfme_prev(:,:) = 0.d0
    matrce(:,:) = 0.d0
    matrce_prev(:,:) = 0.d0
    matrcm(:,:) = 0.d0
    matrcm_prev(:,:) = 0.d0
    matrec(:,:) = 0.d0
    matrec_prev(:,:) = 0.d0
    matrmc(:,:) = 0.d0
    matrmc_prev(:,:) = 0.d0
    matrff(:,:) = 0.d0
    matrff_prev(:,:) = 0.d0
    matrfe(:,:) = 0.d0
    matrfe_prev(:,:) = 0.d0
    matrfm(:,:) = 0.d0
    matrfm_prev(:,:) = 0.d0
    matref(:,:) = 0.d0
    matref_prev(:,:) = 0.d0
    matrmf(:,:) = 0.d0
    matrmf_prev(:,:) = 0.d0
!
    debug = .false.
!
    loptf           = option.eq.'RIGI_FROT'
    call jevech('PCONFR', 'L', jpcf)
    l_previous_cont = (nint(zr(jpcf-1+30)) .eq. 1 )
    l_previous_frot = (nint(zr(jpcf-1+44)) .eq. 1 )
    if (option .eq. 'RIGI_CONT') l_previous = l_previous_cont
    if (option .eq. 'RIGI_FROT') l_previous = l_previous_frot
!
! - Get coefficients
!
    call mmGetCoefficients(coefff, coefac, coefaf, alpha_cont)
    if (l_previous) then
        coefac_prev = coefac
        coefaf_prev = coefaf
    endif
!
! - Get projections datas
!
    call mmGetProjection(iresog  , wpg     ,&
                         xpc     , ypc     , xpr     , ypr     , tau1     , tau2     ,&
                         xpc_prev, ypc_prev, xpr_prev, ypr_prev, tau1_prev, tau2_prev)

!
! - Get algorithms
!
    call mmGetAlgo(l_large_slip, ndexfr  , jeusup, ldyna , lambds,&
                   ialgoc      , ialgof  , iresof, iresog,&
                   lpenac      , lpenaf  ,&
                   lambds_prev , jeu_prev)
!
! - Get informations on cell (slave and master)
!
    call mmelem(nomte , ndim , nddl,&
                typmae, nne  ,&
                typmam, nnm  ,&
                nnl   , nbcps, nbdm,&
                laxis , leltf)
!
! - Compute quantities
!
    call mmtppe(typmae, typmam, ndim, nne, nnm,&
                nnl, nbdm, iresog, laxis, &
                xpc           , ypc      , xpr   , ypr     ,&
                tau1          , tau2     ,&
                jeusup, ffe, ffm, dffm,ddffm, ffl,&
                jacobi, jeu, djeut, dlagrc,&
                dlagrf, norm, mprojn,&
                mprojt, mprt1n, mprt2n, mprnt1, mprnt2,&
                kappa, h, hah, vech1, vech2,&
                mprt11, mprt12, mprt21,&
                mprt22,taujeu1, taujeu2, &
              dnepmait1,dnepmait2, .false._1,l_large_slip)
                
    if (l_previous) then
        call mmtppe(typmae, typmam, ndim, nne, nnm,&
                    nnl, nbdm, iresog, laxis, &
                    xpc           , ypc      , xpr   , ypr     ,&
                    tau1_prev     , tau2_prev,&
                    jeusup_prev, ffe, ffm, dffm,ddffm, ffl,&
                    jacobi, jeu_prev, djeut_prev, dlagrc_prev,&
                    dlagrf_prev, norm_prev, mprojn_prev,&
                    mprojt_prev, mprt1n_prev, mprt2n_prev, mprnt1_prev, mprnt2_prev,&
                    kappa_prev, h_prev, hah_prev, vech1_prev, vech2_prev,&
                    mprt11_prev, mprt12_prev, mprt21_prev,&
                    mprt22_prev,taujeu1_prev, taujeu2_prev, &
              dnepmait1_prev,dnepmait2_prev, .true._1,l_large_slip)  
                          
    endif
!
!  --- PREPARATION DES DONNEES - CHOIX DU LAGRANGIEN DE CONTACT
!
    call mmlagc(lambds, dlagrc, iresof, lambda)
    if (l_previous) then
        call mmlagc(lambds_prev, dlagrc_prev, iresof, lambda_prev)
    endif
!
! - Compute state of contact and friction
!
    call mmmsta(ndim, leltf, lpenaf, loptf, djeut,&
                dlagrf, coefaf, tau1, tau2, lcont,&
                ladhe, lambda, rese, nrese, .false._1)
!
! - Select phase to compute
!
    call mmmpha(loptf, lcont, ladhe, ndexfr, lpenac,&
                lpenaf, phasep)

    if (l_previous) then
!
! ----- Statuts  : previous
!
        call mmmsta(ndim, leltf, lpenaf_prev, loptf, djeut_prev,&
                    dlagrf_prev, coefaf_prev, tau1_prev, tau2_prev, lcont_prev,&
                    ladhe_prev, lambda_prev, rese_prev, nrese_prev, l_previous)
!
! ----- PHASE DE CALCUL : previous
!
        call mmmpha(loptf, lcont_prev, ladhe_prev, ndexfr, lpenac_prev,&
                    lpenaf_prev, phasep_prev)
    endif
!
! - Large sliding hypothesis
!
    if (lcont .and.  (phasep(1:4) .eq. 'GLIS') .and. (l_large_slip) &
        .and. (abs(jeu) .lt. 1.d-6 )) then
        call mngliss(ndim     , kappa    ,&
                     tau1     , tau2     ,&
                     taujeu1  , taujeu2  ,&
                     dnepmait1, dnepmait2,&
                     djeut )
        call mmnsta(ndim, leltf, lpenaf, loptf, djeut,&
                    dlagrf, coefaf, tau1, tau2, lcont,&
                    ladhe, lambda, rese, nrese)
    endif
!
! - Weak form of contact/friction force
!
    call mmtfpe(phasep, iresof, ndim, nne, nnm,&
                nnl, nbcps, wpg, jacobi, ffl,&
                ffe, ffm, norm, tau1, tau2,&
                mprojn, mprojt, rese, nrese, lambda,&
                coefff, coefaf, coefac, dlagrf, djeut,&
                matree, matrmm, matrem, matrme, matrec,&
                matrmc, matref, matrmf)
    if (l_previous) then
        call mmtfpe(phasep_prev, iresof, ndim, nne, nnm,&
                    nnl, nbcps, wpg, jacobi, ffl,&
                    ffe, ffm, norm, tau1_prev, tau2_prev,&
                    mprojn_prev, mprojt_prev, rese_prev, nrese_prev, lambda_prev,&
                    coefff, coefaf_prev, coefac_prev, dlagrf_prev, djeut_prev,&
                    matree_prev, matrmm_prev, matrem_prev, matrme_prev, matrec_prev,&
                    matrmc_prev, matref_prev, matrmf_prev)
    endif
!
! - Non-linear contribution for geometric loop
!
    if (iresog .eq. 1) then
        call mmtgeo(phasep, l_large_slip,&
                    ndim  , nne   , nnm   ,&
                    wpg   , ffe   , ffm   , dffm  , ddffm ,&
                    jacobi, coefac, coefff, jeu   , dlagrc,&
                    mprojn,&
                    mprt1n, mprt2n, mprnt1, mprnt2,&
                    kappa , vech1 , vech2 , h     , hah   ,&
                    mprt11, mprt12, mprt21, mprt22,&
                    matree, matrmm, matrem, matrme)
        if (l_previous) then
            call mmtgeo(phasep_prev, l_large_slip,&
                        ndim       , nne        , nnm        ,&
                        wpg        , ffe        , ffm        , dffm       , ddffm      ,&
                        jacobi     , coefac_prev, coefff     , jeu_prev   , dlagrc_prev,&
                        mprojn_prev,&
                        mprt1n_prev, mprt2n_prev, mprnt1_prev, mprnt2_prev,&
                        kappa_prev , vech1_prev , vech2_prev , h_prev     , hah_prev,&
                        mprt11_prev, mprt12_prev, mprt21_prev, mprt22_prev,&
                        matree_prev, matrmm_prev, matrem_prev, matrme_prev)
        endif
    endif
!
! - Weak form of contact/friction force
!
    call mmtape(phasep, leltf, ndim, nnl, nne,&
                nnm, nbcps, wpg, jacobi, ffl,&
                ffe, ffm, norm, tau1, tau2,&
                mprojt, rese, nrese, lambda, coefff,&
                coefaf, coefac,&
                matrcc, matrff, matrce,&
                matrcm, matrfe, matrfm)
    if (l_previous) then
        call mmtape(phasep_prev, leltf, ndim, nnl, nne,&
                    nnm, nbcps, wpg, jacobi, ffl,&
                    ffe, ffm, norm, tau1_prev, tau2_prev,&
                    mprojt_prev, rese_prev, nrese_prev, lambda_prev, coefff,&
                    coefaf_prev, coefac_prev,&
                matrcc_prev, matrff_prev, matrce_prev,&
                    matrcm_prev, matrfe_prev, matrfm_prev)
    endif
!
! - Excluded nodes
!
    call mmmtex(ndexfr, ndim, nnl, nne, nnm,&
                nbcps, matrff, matrfe, matrfm, matref,&
                matrmf)
    if (l_previous) then
        call mmmtex(ndexfr, ndim, nnl, nne, nnm,&
                    nbcps, matrff_prev, matrfe_prev, matrfm_prev, matref_prev,&
                    matrmf_prev)
    endif

!
! - Assembling
!
    call mmmtas(nbdm, ndim, nnl, nne, nnm,&
                nbcps, matrcc, matree, matrmm, matrem,&
                matrme, matrce, matrcm, matrmc, matrec,&
                matrff, matrfe, matrfm, matrmf, matref,&
                mmat)
    if (l_previous) then
        call mmmtas(nbdm, ndim, nnl, nne, nnm,&
                    nbcps, matrcc_prev, matree_prev, matrmm_prev, matrem_prev,&
                    matrme_prev, matrce_prev, matrcm_prev, matrmc_prev, matrec_prev,&
                    matrff_prev, matrfe_prev, matrfm_prev, matrmf_prev, matref_prev,&
                    mmat_prev)
    endif
!
    if (l_previous) then
            mmat_tmp = alpha_cont*mmat+(1-alpha_cont)*mmat_prev
            count_consistency = 0
            51 continue
            count_consistency = count_consistency+1
            alpha_cont = 0.5*(alpha_cont+1.0)
            mmat_tmp = alpha_cont*mmat+(1.0-alpha_cont)*mmat_prev

            if ( norm2(mmat_tmp-mmat) &
                .gt. 1.d-6*norm2(mmat) .and. count_consistency .le. 15) then 
                       goto 51
            elseif ( norm2(mmat_tmp-mmat) .lt. 1.d-6*norm2(mmat)) then 
                       mmat = mmat_tmp
            else 
                       mmat = 0.9999d0*mmat + 0.0001d0*mmat_tmp
            endif
            ! Ce critere peut influencer les perfs : ssnv505l 26s a 35s. 
    endif
!
! - Copy
!
    if ((lpenac.and.(option.eq.'RIGI_CONT')) .or.&
        ((option.eq.'RIGI_FROT').and.(iresof.ne.0)) .or.&
        (lpenaf.and.(option.eq.'RIGI_FROT'))) then
        call jevech('PMATUNS', 'E', jmatt)
        do j = 1, nddl
            do i = 1, nddl
                ij = j+nddl*(i-1)
                if (lpenac.and.(option.eq.'RIGI_CONT')) then
                        zr(jmatt+ij-1) = mmat(i,j)
                else if ((option.eq.'RIGI_FROT').and.(iresof.ne.0)) then
                        zr(jmatt+ij-1) = mmat(i,j)
                else if (lpenaf.and.(option.eq.'RIGI_FROT')) then
                        zr(jmatt+ij-1) = 1.0 * mmat(i,j)
                endif
                if (debug) then
                    call mmmtdb(mmat(i, j), 'IJ', i, j)
                endif
            enddo
        enddo
    else
        call jevech('PMATUUR', 'E', jmatt)
        do j = 1, nddl
            do i = 1, j
                ij = (j-1)*j/2 + i
                    zr(jmatt+ij-1) = mmat(i,j)
                if (debug) then
                    call mmmtdb(mmat(i, j), 'IJ', i, j)
                endif
            end do
        end do
    endif
!
end subroutine

