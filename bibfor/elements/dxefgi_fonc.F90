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

subroutine dxefgi_fonc(nomte, pgl, epsinif, xyz, ni, sigt)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dxmate.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: nomte
    real(kind=8) :: pgl(3, 3)
    character(len=8) :: epsinif(6)
    real(kind=8) :: xyz(*), ni(*)
    real(kind=8) :: sigt(*)
!     ------------------------------------------------------------------
! --- EFFORTS GENERALISES DE DEFORMATION INITIALE AUX POINTS D'INTEGRATION
! --- POUR LES ELEMENTS COQUES A FACETTES PLANES :
! --- DST, DKT, DSQ, DKQ, Q4G
! --- CALCULES A PARTIR D'UN CHAMP DE DEFORMATIONS INITIALES SOUS FORME
! --- DE FONCTION ET QUI NE PREND PAS EN
! --- COMPTE LES DEFORMATIONS INITIALES DE CISAILLEMENT TRANSVERSE.
!     ------------------------------------------------------------------
!     IN  NOMTE        : NOM DU TYPE D'ELEMENT
!     IN  PGL(3,3)     : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
!                        LOCAL
!     IN  EPSINIF(6)   : FONCTIONS DE DEFORMATIONS INITIALES 
!                        DANS L'ORDRE : EPXX, EPYY, EPXY, KXX, KYY, KXY
!     XYZ              : COORDONNEES DES CONNECTIVITES
!     NI               : FONCTIONS DE FORME
!     OUT SIGT(1)      : EFFORTS  GENERALISES D'ORIGINE THERMIQUE
!                        AUX POINTS D'INTEGRATION
    integer :: multic, itemps, ier
    real(kind=8) :: df(3, 3), dm(3, 3), dmf(3, 3), dc(2, 2), dci(2, 2)
    real(kind=8) :: dmc(3, 2), dfc(3, 2)
    real(kind=8) :: t2iu(4), t2ui(4), t1ve(9)
    aster_logical :: coupmf
    character(len=8) :: nompar(4)
    real(kind=8) :: valpar(4)
    real(kind=8) :: xgau, ygau, zgau
!     ------------------------------------------------------------------
!
! --- INITIALISATIONS :
!     -----------------
!-----------------------------------------------------------------------
    integer :: i, igau, nno, npg
    real(kind=8) :: epxx, epxy, epyy, kxx, kyy, kxy, zero
!-----------------------------------------------------------------------
    zero = 0.0d0
!
    do i = 1, 32
        sigt(i) = zero
    end do
!
    if (nomte .eq. 'MEDKTR3 ' .or. nomte .eq. 'MEDSTR3 ' .or. nomte .eq. 'MEDKTG3 ') then
!
        npg = 3
        nno = 3
!
        else if (nomte.eq.'MEDKQU4 ' .or. nomte.eq.'MEDSQU4 ' .or.&
             nomte.eq.'MEQ4QU4 ' .or. nomte.eq.'MEDKQG4 ') then
        npg = 4
        nno = 4
!
    else
        call utmess('F', 'ELEMENTS_14', sk=nomte)
    endif
!
! --- CALCUL DES MATRICES DE HOOKE DE FLEXION, MEMBRANE,
! --- MEMBRANE-FLEXION, CISAILLEMENT, CISAILLEMENT INVERSE
!     ----------------------------------------------------
!
    call dxmate('RIGI', df, dm, dmf, dc,&
                dci, dmc, dfc, nno, pgl,&
                multic, coupmf, t2iu, t2ui, t1ve)
!
! --- CHOIX DE NOTATIONS PLUS EXPLICITES POUR LES DEFORMATIONS
! --- INITIALES
!     ---------
    call jevech('PTEMPSR', 'L', itemps)
    nompar(1) = 'X'
    nompar(2) = 'Y'
    nompar(3) = 'Z'
    nompar(4) = 'INST'
    valpar(4) = zr(itemps)
!
! --- BOUCLE SUR LES POINTS D'INTEGRATION
!     -----------------------------------
    do igau = 1, npg
!
        xgau = zero
        ygau = zero
        zgau = zero
!
        do i = 1, nno
            xgau = xgau + ni(i+nno*(igau-1))*xyz(1+3*(i-1))
            ygau = ygau + ni(i+nno*(igau-1))*xyz(2+3*(i-1))
            zgau = zgau + ni(i+nno*(igau-1))*xyz(3+3*(i-1))
        enddo
!
        valpar(1) = xgau
        valpar(2) = ygau
        valpar(3) = zgau
!
!  --   INTERPOLATION
!       -------------
        call fointe('FM', epsinif(1), 4, nompar, valpar, epxx, ier)
        call fointe('FM', epsinif(2), 4, nompar, valpar, epyy, ier)
        call fointe('FM', epsinif(3), 4, nompar, valpar, epxy, ier)
        call fointe('FM', epsinif(4), 4, nompar, valpar, kxx, ier)
        call fointe('FM', epsinif(5), 4, nompar, valpar, kyy, ier)
        call fointe('FM', epsinif(6), 4, nompar, valpar, kxy, ier)

        sigt(1+8* (igau-1)) = dm(1,1)*epxx + dm(1,2)*epyy + dm(1,3)* epxy
        sigt(2+8* (igau-1)) = dm(2,1)*epxx + dm(2,2)*epyy + dm(2,3)* epxy
        sigt(3+8* (igau-1)) = dm(3,1)*epxx + dm(3,2)*epyy + dm(3,3)* 2.d0*epxy
!
        sigt(4+8* (igau-1)) = df(1,1)*kxx + df(1,2)*kyy + df(1,3)* kxy
        sigt(5+8* (igau-1)) = df(2,1)*kxx + df(2,2)*kyy + df(2,3)* kxy
        sigt(6+8* (igau-1)) = df(3,1)*kxx + df(3,2)*kyy + df(3,3)* 2.d0*kxy
!
        sigt(7+8* (igau-1)) = zero
        sigt(8+8* (igau-1)) = zero
    end do
!
end subroutine
