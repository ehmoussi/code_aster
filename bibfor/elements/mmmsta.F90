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
    integer, intent(in)  :: ndim
    real(kind=8), intent(in) :: dlagrf(2)
    real(kind=8), intent(in) :: djeut(3)
    real(kind=8), intent(in)  :: coefaf, lambda
    aster_logical, intent(in)   :: loptf, l_previous
    real(kind=8), intent(in)  :: tau1(3), tau2(3)
    aster_logical, intent(out)   :: lpenaf
    aster_logical, intent(out)   :: lcont, ladhe
    aster_logical, intent(inout)   :: leltf
    real(kind=8), intent(out)   :: rese(3), nrese
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
! INOUT  LELTF  : .TRUE. SI ELEMENT DE FROTTEMENT
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
    integer :: indco=-1
    integer :: indadhe=-1,indadhe2=-1
    integer :: ialgoc=-1,ialgof=-1
    aster_logical :: lpenac=.false._1
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
    if (leltf) then
! This test influence highly the NON_REGRESSION & CONVERGENCE 
! ONE MUST HAVE ATTENTION WHEN MODIFYING    
        if (lambda .eq. 0.d0) lcont = .false._1
!        if ( abs(lambda) .lt. 1.d-100) lcont = .false._1
    endif
!
! --- ETAT D'ADHERENCE DU POINT DE CONTACT
!
    
    if (leltf .and. lcont) then
        lpenaf = (ialgof.eq.3) .or. &
                 nint(zr(jpcf-1+46)) .eq. 4
        call mmtrpr(ndim, lpenaf, djeut, dlagrf, coefaf,&
                    tau1, tau2, ladhe, rese, nrese)
! On est en penalisatio  ou en algo_cont=penalisation, algo_frot=standard/penalisation
        if (indadhe .eq. 1 .and. l_previous) ladhe = .true. 
        lpenac = (ialgoc.eq.3) 
        if (indadhe2 .eq. 1 .and. lpenac .and. .not. (ialgof.eq.3)  ) ladhe = .true.

    endif
!
!
end subroutine
