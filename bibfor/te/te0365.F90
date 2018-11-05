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

subroutine te0365(option, nomte)
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/mmelem.h"
#include "asterfort/mmlagc.h"
#include "asterfort/mmmlav.h"
#include "asterfort/mmmlcf.h"
#include "asterfort/mmmpha.h"
#include "asterfort/mmnsta.h"
#include "asterfort/mngliss.h"
#include "asterfort/mmmsta.h"
#include "asterfort/mmmvas.h"
#include "asterfort/mmmvex.h"
#include "asterfort/mmvape.h"
#include "asterfort/mmvfpe.h"
#include "asterfort/mmvppe.h"
#include "asterfort/vecini.h"
    character(len=16) :: option, nomte
!
! ----------------------------------------------------------------------
!
!  CALCUL DES SECONDS MEMBRES DE CONTACT ET DE FROTTEMENT DE COULOMB STD
!        AVEC LA METHODE CONTINUE
!
!  OPTION : 'CHAR_MECA_CONT' (CALCUL DU SECOND MEMBRE DE CONTACT)
!           'CHAR_MECA_FROT' (CALCUL DU SECOND MEMBRE DE
!                              FROTTEMENT STANDARD )
!
!  ENTREES  ---> OPTION : OPTION DE CALCUL
!           ---> NOMTE  : NOM DU TYPE ELEMENT
!
! ----------------------------------------------------------------------
!
    integer :: iddl
    integer :: nne, nnm, nnl
    integer :: nddl, ndim, nbcps, nbdm
    integer :: jvect, jpcf
    integer :: iresof, iresog
    integer :: ndexfr
!    
    real(kind=8) :: norm(3)=0.0, tau1(3)=0.0, tau2(3)=0.0
    real(kind=8) :: mprojt(3, 3)=0.0,mprojn(3, 3)=0.0
    real(kind=8) :: rese(3)=0.0, nrese=0.0
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: coefff=0.0, lambda=0.0, lambds=0.0
    real(kind=8) :: coefac=0.0, coefaf=0.0
    real(kind=8) :: jeusup=0.0
    real(kind=8) :: dlagrc=0.0, dlagrf(2)=0.0
    real(kind=8) :: jeu=0.0, djeu(3)=0.0, djeut(3)=0.0
    character(len=8) :: typmae, typmam
    character(len=9) :: phasep
    real(kind=8) :: alpha_cont=1.0
!    
    aster_logical :: laxis = .false. , leltf = .false. 
    aster_logical :: lpenac = .false. , lpenaf = .false. 
    aster_logical :: loptf = .false. , ldyna = .false. ,  lcont = .false. 
    aster_logical :: ladhe = .false. , l_large_slip = ASTER_FALSE
    aster_logical :: l_previous_cont = .false. , l_previous_frot = .false. , l_previous = .false. 
!    
    aster_logical :: debug = .false. 
    real(kind=8) :: ffe(9), ffm(9), ffl(9), dffm(2, 9)
!
    real(kind=8) :: vectcc(9)
    real(kind=8) :: vectff(18)
    real(kind=8) :: vectee(27), vectmm(27)
    real(kind=8) :: vtmp(81)
!
    character(len=24) :: typelt
    real(kind=8) :: dnepmait1 ,dnepmait2 ,taujeu1,taujeu2
!
    real(kind=8) :: mprt1n(3, 3), mprt2n(3, 3)
    real(kind=8) :: mprnt1(3, 3), mprnt2(3, 3)
    real(kind=8) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
!
    real(kind=8) :: gene11(3, 3), gene21(3, 3), gene22(3, 3)
    real(kind=8) :: kappa(2, 2), a(2, 2), h(2, 2), ha(2, 2), hah(2, 2)
!
    real(kind=8) :: vech1(3), vech2(3)
    
!
! ----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    call vecini(81, 0.d0, vtmp)
    call vecini(9, 0.d0, vectcc)
    call vecini(18, 0.d0, vectff)
    call vecini(27, 0.d0, vectee)
    call vecini(27, 0.d0, vectmm)
    
    dnepmait1 =0.0
    dnepmait2 =0.0
    taujeu1   =0.0
    taujeu2   =0.0
    
    debug = ASTER_FALSE
    l_large_slip = ASTER_FALSE
!
! --- TYPE DE MAILLE DE CONTACT
!
    typelt = 'POIN_ELEM'
    loptf = option.eq.'CHAR_MECA_FROT'
    call jevech('PCONFR', 'L', jpcf)
    l_previous_cont = (nint(zr(jpcf-1+30)) .eq. 1 )
    l_previous_frot = (nint(zr(jpcf-1+44)) .eq. 1 ) .and. .false.
    if (option .eq. 'RIGI_CONT') l_previous = l_previous_cont
    if (option .eq. 'RIGI_FROT') l_previous = l_previous_frot
    l_large_slip = nint(zr(jpcf-1+48)).eq. 1
    
!
! --- PREPARATION DES CALCULS - INFOS SUR LA MAILLE DE CONTACT
!
    call mmelem(nomte, ndim, nddl, typmae, nne,&
                typmam, nnm, nnl, nbcps, nbdm,&
                laxis, leltf)
!
! --- PREPARATION DES CALCULS - LECTURE DES COEFFICIENTS 
!                             - LECTURE FONCTIONNALITES AVANCEES
!
    call mmmlcf(coefff, coefac, coefaf, lpenac, lpenaf,&
                iresof, iresog, lambds, .false._1)
                
    call mmmlav(ldyna, jeusup, ndexfr)
                

!
! --- PREPARATION DES DONNEES
!
    if (typelt .eq. 'POIN_ELEM') then
!
! ----- CALCUL DES QUANTITES
!
        call mmvppe(typmae, typmam, iresog, ndim, nne,&
                  nnm, nnl, nbdm, laxis, ldyna,&
                  jeusup, ffe, ffm, dffm, ffl,&
                  norm, tau1, tau2, mprojt, jacobi,&
                  wpg, dlagrc, dlagrf, jeu, djeu,&
                  djeut, mprojn,&
                  mprt1n, mprt2n, mprnt1, mprnt2,&
                  gene11, gene21,&
                  gene22, kappa, h, vech1, vech2,&
                  a, ha, hah, mprt11, mprt12, mprt21,&
                  mprt22,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2, l_previous,l_large_slip)

!  --- PREPARATION DES DONNEES - CHOIX DU LAGRANGIEN DE CONTACT
!
        call mmlagc(lambds, dlagrc, iresof, lambda)

!
! ----- STATUTS
!
        call mmmsta(ndim, leltf, lpenaf, loptf, djeut,&
                    dlagrf, coefaf, tau1, tau2, lcont,&
                    ladhe, lambda, rese, nrese,.false._1)
!
! ----- PHASE DE CALCUL : current
!
        call mmmpha(loptf, lcont, ladhe, ndexfr, lpenac,&
                    lpenaf, phasep)
                    


!
! Modification du jeu tangent pour le grand glissement
!

     if (lcont .and.  (phasep(1:4) .eq. 'GLIS') .and. (l_large_slip)&
         .and. (abs(jeu) .lt. 1.d-6 )) then
        call mngliss(tau1  ,tau2  ,djeut,kappa ,taujeu1, taujeu2, &
                     dnepmait1,dnepmait2,ndim )
        call mmnsta(ndim, leltf, lpenaf, loptf, djeut,&
                    dlagrf, coefaf, tau1, tau2, lcont,&
                    ladhe, lambda, rese, nrese)
      endif
    else
        ASSERT(.false.)
    endif
!
! --- CALCUL FORME FAIBLE FORCE DE CONTACT/FROTTEMENT
!
    if (typelt .eq. 'POIN_ELEM') then
        call mmvfpe(phasep, ndim, nne, nnm, norm,&
                    tau1, tau2, mprojt, wpg, ffe,&
                    ffm, jacobi, jeu, coefac, coefaf,&
                    lambda, coefff, dlagrc, dlagrf, djeu,&
                    rese, nrese, &
                    vectee, vectmm,mprt11,mprt21,mprt22,mprt1n,mprt2n,kappa,l_large_slip)
    else
        ASSERT(.false.)
    endif
!
! --- CALCUL FORME FAIBLE LOI DE CONTACT/FROTTEMENT
!
    if (typelt .eq. 'POIN_ELEM') then
        call mmvape(phasep, leltf, ndim, nnl, nbcps,&
                    coefac, coefaf, coefff, ffl, wpg,&
                    jeu, jacobi, lambda, tau1, tau2,&
                    mprojt, dlagrc, dlagrf, djeu, rese,&
                    vectcc, vectff)
    else
        ASSERT(.false.)
    endif
!
! --- MODIFICATIONS EXCLUSION
!
    call mmmvex(nnl, nbcps, ndexfr, vectff)
!
! --- ASSEMBLAGE FINAL
!
    call mmmvas(ndim, nne, nnm, nnl, nbdm,&
                nbcps, vectee, vectmm, vectcc, vectff,&
                vtmp)
    
!---------------------------------------------------------------
!-------------- RECOPIE DANS LA BASE DE TRAVAIL ----------------
!---------------------------------------------------------------

    alpha_cont = zr(jpcf-1+31)

!
! --- RECUPERATION DES VECTEURS 'OUT' (A REMPLIR => MODE ECRITURE)
!
    call jevech('PVECTUR', 'E', jvect)
!
! --- RECOPIE VALEURS FINALES
!
    do iddl = 1, nddl
            zr(jvect-1+iddl) = 1.0d0 * vtmp(iddl)
        
!        if (debug) then
!            if (vtmp(iddl) .ne. 0.d0) then
!                write(6,*) 'TE0365: ',iddl,vtmp(iddl)
!            endif
!        endif
    end do
!
end subroutine
