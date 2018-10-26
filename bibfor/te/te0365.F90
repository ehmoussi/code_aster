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
#include "asterfort/mmmpha.h"
#include "asterfort/mmmsta.h"
#include "asterfort/mmnsta.h"
#include "asterfort/mngliss.h"
#include "asterfort/mmmvas.h"
#include "asterfort/mmmvex.h"
#include "asterfort/mmvape.h"
#include "asterfort/mmvfpe.h"
#include "asterfort/mmvppe.h"
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
    integer :: iddl, jvect
    integer :: nne, nnm, nnl
    integer :: nddl, ndim, nbcps, nbdm
    integer :: iresof, iresog, ialgoc, ialgof
    integer :: ndexfr
    integer :: indco
    character(len=8) :: typmae, typmam
    character(len=4) :: phase
    aster_logical :: laxis = .false. , leltf = .false.
    aster_logical :: l_pena_cont = .false. , l_pena_fric = .false.
    aster_logical :: lcont = .false., ladhe = .false., l_fric_no = .false.
    aster_logical :: debug = .false.
    real(kind=8) :: coefff = 0.0
    real(kind=8) :: lambda = 0.0, lambds = 0.0
    real(kind=8) :: coefac = 0.0, coefaf = 0.0
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: norm(3) = 0.0, tau1(3) = 0.0, tau2(3) = 0.0
    real(kind=8) :: jeusup=0.0
    real(kind=8) :: dlagrc=0.0, dlagrf(2)=0.0
    real(kind=8) :: jeu=0.0, djeut(3)=0.0
    real(kind=8) :: rese(3)=0.0, nrese=0.0
    real(kind=8) :: mprojt(3, 3)=0.0
    real(kind=8) :: mprt1n(3, 3)=0.0, mprt2n(3, 3)=0.0
    real(kind=8) :: mprt11(3, 3)=0.0, mprt12(3, 3)=0.0, mprt21(3, 3)=0.0, mprt22(3, 3)=0.0
    real(kind=8) :: kappa(2, 2)=0.0
    real(kind=8) :: ffe(9), ffm(9), ffl(9), dffm(2,9)
    real(kind=8) :: alpha_cont=0.0
    real(kind=8) :: dnepmait1, dnepmait2, taujeu1, taujeu2
    real(kind=8) :: xpc, ypc, xpr, ypr
    aster_logical :: l_large_slip = ASTER_FALSE
    real(kind=8) :: djeu(3)=0.0
!
    real(kind=8) :: vectcc(9)
    real(kind=8) :: vectff(18)
    real(kind=8) :: vectee(27), vectmm(27)
    real(kind=8) :: vtmp(81)
!
! --------------------------------------------------------------------------------------------------
!
    vtmp(:)   = 0.d0
    vectcc(:) = 0.d0
    vectff(:) = 0.d0
    vectee(:) = 0.d0
    vectmm(:) = 0.d0
    debug = ASTER_FALSE
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
    call mmGetProjection(iresog, wpg,&
                         xpc   , ypc, xpr, ypr, tau1, tau2)
!
! - Get algorithms
!
    call mmGetAlgo(l_large_slip, ndexfr, jeusup, lambds,&
                   ialgoc      , ialgof, iresof, iresog,&
                   l_pena_cont , l_pena_fric)
!
! - Get status
!
    call mmGetStatus(leltf, indco)
!
! - Compute quantities (for vector)
!
    call mmvppe(typmae   , typmam   ,&
                ndim     , nne      , nnm     , nnl    , nbdm ,&
                iresog   , l_large_slip,&
                laxis    , jeusup   ,&
                xpc      , ypc      , xpr     , ypr   ,&
                tau1     , tau2     ,&
                ffe      , ffm      , ffl     , dffm  ,&
                jacobi   , jeu      , djeu    , djeut ,&
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
    call mmlagc(lambds, dlagrc, iresof, lambda)
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
                vectee, vectmm)
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
    call mmmvas(ndim, nne, nnm, nnl, nbdm,&
                nbcps, vectee, vectmm, vectcc, vectff,&
                vtmp)
!
! - Copy
!
    call jevech('PVECTUR', 'E', jvect)
    do iddl = 1, nddl
        zr(jvect-1+iddl) = 1.0d0 * vtmp(iddl)
    end do
!
end subroutine
