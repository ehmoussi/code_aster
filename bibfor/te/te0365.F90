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
subroutine te0365(option, nomte)
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
#include "asterfort/mngliss.h"
#include "asterfort/mmmvas.h"
#include "asterfort/mmmvex.h"
#include "asterfort/mmvape.h"
#include "asterfort/mmvfpe.h"
#include "asterfort/mmvppe.h"
#include "asterfort/writeVector.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Options: CHAR_MECA_CONT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nne, nnm, nnl
    integer :: nddl, ndim, nbcps, nbdm
    integer :: i_reso_fric, i_reso_geom, ialgoc, ialgof
    integer :: ndexfr
    integer :: indco
    character(len=8) :: typmae, typmam
    character(len=4) :: phase
    aster_logical :: laxis, leltf
    aster_logical :: l_pena_cont, l_pena_fric
    aster_logical :: lcont, ladhe, l_fric_no
    aster_logical :: debug
    real(kind=8) :: coefff
    real(kind=8) :: lambda, lambds
    real(kind=8) :: coefac, coefaf
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: norm(3), tau1(3), tau2(3)
    real(kind=8) :: jeusup
    real(kind=8) :: dlagrc, dlagrf(2)
    real(kind=8) :: jeu, djeut(3)
    real(kind=8) :: rese(3), nrese
    real(kind=8) :: mprojt(3,3)
    real(kind=8) :: mprt1n(3,3), mprt2n(3,3)
    real(kind=8) :: mprt11(3,3), mprt12(3,3), mprt21(3,3), mprt22(3,3)
    real(kind=8) :: kappa(2, 2)
    real(kind=8) :: ffe(9), ffm(9), ffl(9)
    real(kind=8) :: ddffm(3, 9), dffm(2, 9)
    real(kind=8) :: alpha_cont
    real(kind=8) :: dnepmait1, dnepmait2, taujeu1, taujeu2
    real(kind=8) :: xpc, ypc, xpr, ypr
    aster_logical :: l_large_slip
    real(kind=8) :: djeu(3)
!
    real(kind=8) :: vectcc(9)
    real(kind=8) :: vectff(18)
    real(kind=8) :: vectce(27), vectcm(27), vectfe(27), vectfm(27)
    real(kind=8) :: vcont(81), vfric(81)
!
! --------------------------------------------------------------------------------------------------
!
    vcont(:)  = 0.d0
    vfric(:)  = 0.d0
    vectcc(:) = 0.d0
    vectff(:) = 0.d0
    vectce(:) = 0.d0
    vectcm(:) = 0.d0
    vectfe(:) = 0.d0
    vectfm(:) = 0.d0
    djeu(:)=0.0
    alpha_cont=0.0
    coefff = 0.0
    lambda = 0.0
    lambds = 0.0
    coefac = 0.0
    coefaf = 0.0
    norm(:) = 0.0
    tau1(:) = 0.0
    tau2(:) = 0.0
    jeusup=0.0
    dlagrc=0.0
    dlagrf(:)=0.0
    jeu=0.0
    djeut(:)=0.0
    rese(:)=0.0
    nrese=0.0
    mprojt(:,:) = 0.d0
    mprt1n(:,:) = 0.d0
    mprt2n(:,:) = 0.d0
    mprt11(:,:) = 0.d0
    mprt12(:,:) = 0.d0
    mprt21(:,:) = 0.d0
    mprt22(:,:) = 0.d0
    debug = ASTER_FALSE
    laxis = ASTER_FALSE
    leltf = ASTER_FALSE
    lcont = ASTER_FALSE
    ladhe = ASTER_FALSE
    l_fric_no = ASTER_FALSE
    l_large_slip = ASTER_FALSE
!
! - Get informations on cell (slave and master)
!
    call mmelem(nomte , ndim , nddl,&
                typmae, nne  ,&
                typmam, nnm  ,&
                nnl   , nbcps, nbdm,&
                laxis , leltf)
!
! - Get coefficients
!
    call mmGetCoefficients(coefff, coefac, coefaf, alpha_cont)
!
! - Get projections datas
!
    call mmGetProjection(i_reso_geom, wpg,&
                         xpc   , ypc, xpr, ypr, tau1, tau2)
!
! - Get algorithms
!
    call mmGetAlgo(l_large_slip, ndexfr, jeusup, lambds,&
                   ialgoc      , ialgof, i_reso_fric, i_reso_geom,&
                   l_pena_cont , l_pena_fric)
!
! - Get status
!
    call mmGetStatus(indco)
!
! - Get shape functions
!
    call mmGetShapeFunctions(laxis, typmae, typmam, &
                             ndim , nne   , nnm   , &
                             xpc  , ypc   , xpr   , ypr  ,&
                             ffe  , ffm   , dffm  , ddffm,&
                             ffl  , jacobi)
!
! - Compute quantities (for vector)
!
    call mmvppe(ndim     , nne      , nnm     , nnl    , nbdm ,&
                i_reso_geom, l_large_slip,&
                jeusup   ,&
                tau1     , tau2     ,&
                ffe      , ffm      , ffl     , dffm   , ddffm,&
                jeu      , djeu    , djeut ,&
                dlagrc   , dlagrf   , &
                norm     , mprojt   ,&
                mprt1n   , mprt2n   , &
                mprt11   , mprt12   , mprt21  , mprt22,&
                kappa    , &
                taujeu1  , taujeu2  ,&
                dnepmait1, dnepmait2)
!
! - Get contact pressure
!
    call mmlagc(lambds, dlagrc, i_reso_fric, lambda)
!
! - Compute state of contact and friction
!
    call mmmsta(ndim       , leltf , indco,&
                ialgoc     , ialgof,&
                l_pena_fric, coefaf,&
                lambda     , djeut , dlagrf,&
                tau1       , tau2  ,&
                lcont      , ladhe , l_fric_no,&
                rese       , nrese)
!
! - Select phase to compute
!
    call mmmpha(leltf, lcont, ladhe, l_fric_no, phase)
!
! - Large sliding hypothesis
!
    if (lcont .and. (phase .eq. 'GLIS') .and. (l_large_slip) .and. (abs(jeu) .lt. 1.d-6 )) then
        call mngliss(ndim     , kappa    ,&
                     tau1     , tau2     ,&
                     taujeu1  , taujeu2  ,&
                     dnepmait1, dnepmait2,&
                     djeut )
        call mmnsta(ndim  , leltf ,&
                    l_pena_fric, coefaf,&
                    indco ,&
                    lambda, djeut , dlagrf,&
                    tau1  , tau2  ,&
                    lcont , ladhe ,&
                    rese  , nrese)
    endif
!
! - Weak form of contact/friction force
!
    call mmvfpe(phase , l_pena_cont, l_pena_fric, l_large_slip,&
                ndim  , nne   , nnm   ,&
                norm  , tau1  , tau2  , mprojt,&
                wpg   , ffe   , ffm   , dffm  , jacobi, jeu   ,&
                coefac, coefaf, lambda, coefff,&
                dlagrc, dlagrf, djeu  ,&
                rese  , nrese ,&
                mprt1n, mprt2n,&
                mprt11, mprt12, mprt21, mprt22, kappa,&
                vectce, vectcm, vectfe, vectfm)
!
! - Weak form of contact/friction law
!
    call mmvape(phase , leltf , l_pena_cont, l_pena_fric,&
                ndim  , nnl   , nbcps      ,&
                ffl   ,&
                wpg   , jacobi, jeu   , djeu, lambda,&
                coefac, coefaf, coefff, &
                tau1  , tau2  , mprojt, &
                dlagrc, dlagrf, rese,&
                vectcc, vectff)
!
! - Excluded nodes
!
    call mmmvex(nnl, nbcps, ndexfr, vectff)
!
! - Assembling
!
    call mmmvas(ndim  , nne   , nnm   , nnl   , nbdm, nbcps,&
                vectce, vectcm, vectfe, vectfm,&
                vectcc, vectff,&
                vcont , vfric)
!
! - Copy
!
    call writeVector('PVECTCR', nddl, vcont)
    if (leltf) then
        call writeVector('PVECTFR', nddl, vfric)
    endif
!
end subroutine
