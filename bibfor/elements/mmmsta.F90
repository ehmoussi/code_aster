! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine mmmsta(ndim, leltf, lpenaf, loptf, djeut,&
                  dlagrf, coefaf, tau1, tau2, lcont,&
                  ladhe, lambda, rese, nrese, l_previous)
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/mmtrpr.h"
!
    integer :: ndim
    real(kind=8) :: dlagrf(2), djeut(3)
    aster_logical :: loptf, lpenaf, leltf, l_previous,lpenac
    real(kind=8) :: tau1(3), tau2(3)
    aster_logical :: lcont, ladhe
    real(kind=8) :: rese(3), nrese, lambda
    real(kind=8) :: coefaf
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! PREPARATION DES CALCULS - LECTURE DES STATUTS
!
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  LPENAF : .TRUE. SI FROTTEMENT PENALISE
! IN  LELTF  : .TRUE. SI ELEMENT DE FROTTEMENT
! IN  LOPTF  : .TRUE. SI OPTION  DE FROTTEMENT
! IN  DLAGRF : INCREMENT DEPDEL DES LAGRANGIENS DE FROTTEMENT
! IN  DJEUT  : INCREMENT DEPDEL DU JEU TANGENT
! IN  COEFAF : COEF_AUGM_FROT
! IN  TAU1   : PREMIER VECTEUR TANGENT
! IN  TAU2   : SECOND VECTEUR TANGENT
! IN LAMBDA : VALEUR DU MULT. DE CONTACT (SEUIL FIXE)
! OUT LCONT  : .TRUE. SI CONTACT (SU=1)
! OUT LADHE  : .TRUE. SI ADHERENCE
! OUT RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
!               GTK = LAMBDAF + COEFAF*VITESSE
! OUT NRESE  : NORME DU SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
!
!
!
!
    integer :: jpcf
    integer :: indco
    integer :: indadhe,indadhe2
    integer :: ialgoc,ialgof
!
! ----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    lcont = .false.
    ladhe = .false.
    lpenac = .false.
    lpenaf = .false.
    nrese = 0.d0
    rese(1) = 0.d0
    rese(2) = 0.d0
    rese(3) = 0.d0
!
! --- RECUPERATION DES STATUTS
!
    call jevech('PCONFR', 'L', jpcf)
    ialgoc = nint(zr(jpcf-1+15))
    ialgof = nint(zr(jpcf-1+18))
    if (l_previous) then 
        indco = nint(zr(jpcf-1+27))
        indadhe = nint(zr(jpcf-1+44))
        indadhe2 = nint(zr(jpcf-1+47))
    else 
        indco = nint(zr(jpcf-1+12))
        indadhe2 = nint(zr(jpcf-1+47))   
    endif
    
    lpenac = (ialgoc.eq.3) .or. &
              nint(zr(jpcf-1+45)) .eq. 4
              
    lpenaf = (ialgof.eq.3) .or. &
             nint(zr(jpcf-1+46)) .eq. 4
!
! --- STATUT DU CONTACT
!
    lcont = (indco.eq.1) 
!
! --- PAS DE FROTTEMENT SI CALCUL OPTION CONTACT
!
    if (.not.loptf) then
        leltf = .false.
    endif
!
! --- STATUT DU CONTACT - CAS DU FROTTEMENT
!
!
    if (loptf) then
! This test influence highly the NON_REGRESSION & CONVERGENCE 
! ONE MUST HAVE ATTENTION WHEN MODIFYING    
        if (lambda .eq. 0.d0) lcont = .false._1
!        if ( abs(lambda) .lt. 1.d-100) lcont = .false._1
    endif
!
! --- ETAT D'ADHERENCE DU POINT DE CONTACT
!
    
    if (loptf .and. lcont) then
        call mmtrpr(ndim, lpenaf, djeut, dlagrf, coefaf,&
                    tau1, tau2, ladhe, rese, nrese)
        if (indadhe .eq. 1 .and. l_previous) ladhe = .true. 
! On est en penalisatio  ou en algo_cont=penalisation, algo_frot=standard/penalisation
        if (indadhe2 .eq. 2 ) ladhe = .true. 

    endif
!
!
end subroutine
