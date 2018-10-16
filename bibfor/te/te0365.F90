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
! Options: CHAR_MECA_CONT / CHAR_MECA_FROT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iddl, jvect
    integer :: nne, nnm, nnl
    integer :: nddl, ndim, nbcps, nbdm
    integer :: iresof, iresog, ialgoc, ialgof
    integer :: ndexfr
    character(len=8) :: typmae, typmam
    character(len=9) :: phasep
    aster_logical :: laxis = .false. , leltf = .false.
    aster_logical :: lpenac = .false. , lpenaf = .false.
    aster_logical :: loptf = .false. , ldyna = .false., lcont = .false., ladhe = .false.
    aster_logical :: l_previous = .false.
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
    real(kind=8) :: mprnt1(3, 3)=0.0, mprnt2(3, 3)=0.0
    real(kind=8) :: mprt11(3, 3)=0.0, mprt12(3, 3)=0.0, mprt21(3, 3)=0.0, mprt22(3, 3)=0.0
    real(kind=8) :: kappa(2, 2)=0.0
    real(kind=8) :: mprojn(3, 3)=0.0, h(2, 2)=0.d0
    real(kind=8) :: vech1(3)=0.0, vech2(3)=0.0
    real(kind=8) :: ffe(9), ffm(9), ffl(9)
    real(kind=8) :: dffm(2, 9)
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
    vtmp (:) = 0.d0
    vectcc(:) = 0.d0
    vectff(:) = 0.d0
    vectee(:) = 0.d0
    vectmm(:) = 0.d0

    debug = ASTER_FALSE
    loptf = option.eq.'CHAR_MECA_FROT'
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
    call mmGetAlgo(l_large_slip, ndexfr, jeusup, ldyna , lambds,&
                   ialgoc      , ialgof, iresof, iresog,&
                   lpenac      , lpenaf)
!
! - Get informations on cell (slave and master)
!
    call mmelem(nomte , ndim , nddl,&
                typmae, nne  ,&
                typmam, nnm  ,&
                nnl   , nbcps, nbdm,&
                laxis , leltf)
!
! - Compute quantities (for vector)
!
    call mmvppe(typmae, typmam, iresog, ndim, nne,&
                nnm, nnl, nbdm, laxis, ldyna,&
                xpc        , ypc      , xpr     , ypr     ,&
                tau1, tau2,&
                jeusup, ffe, ffm, dffm, ffl,&
                norm, mprojt, jacobi,&
                dlagrc, dlagrf, jeu, djeu,&
                djeut, mprojn,&
                mprt1n, mprt2n, mprnt1, mprnt2,&
                kappa, h, vech1, vech2,&
                mprt11, mprt12, mprt21,&
                mprt22,taujeu1, taujeu2, &
                dnepmait1,dnepmait2, l_previous,l_large_slip)
!
!  --- PREPARATION DES DONNEES - CHOIX DU LAGRANGIEN DE CONTACT
!
    call mmlagc(lambds, dlagrc, iresof, lambda)
!
! - Compute state of contact and friction
!
    call mmmsta(ndim, leltf, lpenaf, loptf, djeut,&
                dlagrf, coefaf, tau1, tau2, lcont,&
                ladhe, lambda, rese, nrese,.false._1)
!
! - Select phase to compute
!
    call mmmpha(loptf, lpenac, lpenaf,&
                lcont, ladhe ,&
                phasep)
!
! - Large sliding hypothesis
!
    if (lcont .and.  (phasep(1:4) .eq. 'GLIS') .and. (l_large_slip)&
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
    call mmvfpe(phasep, ndim, nne, nnm, norm,&
                tau1, tau2, mprojt, wpg, ffe,&
                ffm, jacobi, jeu, coefac, coefaf,&
                lambda, coefff, dlagrc, dlagrf, djeu,&
                rese, nrese, &
                vectee, vectmm,mprt11,mprt21,mprt22,mprt1n,mprt2n,kappa,l_large_slip)
!
! - Weak form of contact/friction law
!
    call mmvape(phasep, leltf, ndim, nnl, nbcps,&
                coefac, coefaf, coefff, ffl, wpg,&
                jeu, jacobi, lambda, tau1, tau2,&
                mprojt, dlagrc, dlagrf, djeu, rese,&
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
