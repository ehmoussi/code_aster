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

subroutine reeref(elrefp, nnop, geom, xg, ndim, xe, ff, dfdi)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/elrfdf.h"
#include "asterfort/elrfvf.h"
#include "asterfort/invjax.h"
#include "asterfort/matini.h"
#include "asterfort/reereg.h"
    integer, intent(in) :: ndim
    integer, intent(in) :: nnop
    character(len=8), intent(in) :: elrefp
    real(kind=8), intent(in) :: geom(*)
    real(kind=8), intent(in) :: xg(ndim)
    real(kind=8), intent(out) :: xe(ndim)
    real(kind=8), intent(out) :: ff(nnop)
    real(kind=8), optional, intent(out) :: dfdi(nnop, ndim)
!
! ----------------------------------------------------------------------
!
! TROUVER LES COORDONNEES DANS L'ELEMENT DE REFERENCE D'UN
! POINT DONNE DANS L'ELEMENT REEL PAR LA METHODE NEWTON
! ET CALCUL DES FONCTIONS DE FORME CLASSIQUES ET DE LEURS 
! DERIVEES EN XE
!
! ----------------------------------------------------------------------
!
!
! IN  ELREFP : TYPE DE L'ELEMENT DE REF PARENT
! IN  NNOP   : NOMBRE DE NOEUDS DE L'ELT DE RÉF PARENT
!   L'ORDRE DES DDLS DOIT ETRE 'DC' 'H1' 'E1' 'E2' 'E3' 'E4' 'LAGC'
! IN  GEOM   : COORDONNEES DES NOEUDS
! IN  XG     : COORDONNES DU POINT DANS L'ELEMENT REEL
! IN  NDIM   : DIMENSION DE L'ESPACE
! OUT XE     : COORDONNÉES DU POINT DANS L'ÉLÉMENT DE RÉF PARENT
! OUT FF     : FONCTIONS DE FORMES EN XE
! OUT DFDI   : DÉRIVÉES DES FONCTIONS DE FORMES EN XE
!
    integer :: nbnomx
    parameter   (nbnomx = 27)
!
    integer :: i, k, n
    integer :: nno, nderiv, iret
    real(kind=8) :: invjac(3, 3)
    real(kind=8) :: dff(3, nbnomx)
!
! ----------------------------------------------------------------------
!
!
! --- RECHERCHE DE XE PAR NEWTON-RAPHSON
!
    call reereg('S', elrefp, nnop, geom, xg,&
                ndim, xe, iret)
!
! --- VALEURS DES FONCTIONS DE FORME EN XE: FF
!
    call elrfvf(elrefp, xe, nbnomx, ff, nno)
!
! --- SI L'ARGUMENT OPTIONNEL DFDI EST PRESENT -> CALCUL DES DERIVEES
!
    if ( present(dfdi) ) then
!
! ------- DERIVEES PREMIERES DES FONCTIONS DE FORME EN XE: DFF
        call elrfdf(elrefp, xe, ndim*nbnomx, dff, nno,&
                    nderiv)
!
! ------- CALCUL DE L'INVERSE DE LA JACOBIENNE EN XE: INVJAC
        call invjax('S', nno, ndim, nderiv, dff,&
                    geom, invjac, iret)
!
! ------- DERIVEES DES FONCTIONS DE FORMES CLASSIQUES EN XE : DFDI
        call matini(nnop, ndim, 0.d0, dfdi)
        do 310 i = 1, ndim
            do 300 n = 1, nno
                do 311 k = 1, ndim
                    dfdi(n,i)= dfdi(n,i) + invjac(k,i)*dff(k,n)
311              continue
300          continue
310      end do
!
    end if 
!
!
! ----------------------------------------------------------------------
!
end subroutine
