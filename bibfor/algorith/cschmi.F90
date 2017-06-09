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

subroutine cschmi(ca, ndim, cvec, cbas, ndimax,&
                  nbbas)
    implicit none
!
!***********************************************************************
!    P. RICHARD                                 DATE 31/07/91
!-----------------------------------------------------------------------
!  BUT: < COMPLEXE ORTHOGONALISATION DE SCHMIDT >
!
! ORTHOGONALISER UN VECTEUR COMPLEXE A DES VECTEURS DE REFERENCE
!  PAR RAPPORT A UNE MATRICE COMPLEXES HERMITIENNE
!
!-----------------------------------------------------------------------
!
! CA       /I/: MATRICE CARRE COMPLEXE SERVANT DE NORME
! NDIM     /I/: DIMENSION DE LA MATRICE
! CVEC     /M/: VECTEUR A ORTHOGONALISER
! CBAS     /I/: MATRICE DES VECTEURS DE REFERENCE
! NBBAS    /I/: NOMBRE DES VECTEURS DE REFERENCE
!
!-----------------------------------------------------------------------
!
#include "asterfort/cvnorm.h"
#include "asterfort/utmess.h"
#include "asterfort/zconju.h"
    complex(kind=8) :: ca(*)
    complex(kind=8) :: cbas(ndimax, nbbas)
    complex(kind=8) :: cvec(ndim), ctrav1, ctrav2, cprod, cconj, cmodu
    real(kind=8) :: prea, pima
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
! CAS OU IL N'Y A PAS DE VECTEUR DE REFERENCE
!
!-----------------------------------------------------------------------
    integer :: i, ic, icdiag, il, ildiag, iretou, j
    integer :: nbbas, ndim, ndimax
!-----------------------------------------------------------------------
    if (nbbas .eq. 0) then
!
!   NORMALISATION
!
        call cvnorm(ca, cvec, ndim, iretou)
        if (iretou .eq. 1) then
            call utmess('F', 'ALGORITH2_22')
        endif
!
        goto 9999
    endif
!
!       BOUCLE SUR LES VECTEURS DE REFERENCE
!
    do 10 j = 1, nbbas
!
!   MULTIPLICATION ET CALCUL PRODUIT ET NORMES
!
        cprod=dcmplx(0.d0,0.d0)
        cmodu=dcmplx(0.d0,0.d0)
        do 20 il = 1, ndim
            ctrav1=dcmplx(0.d0,0.d0)
            ctrav2=dcmplx(0.d0,0.d0)
            ildiag = il*(il-1)/2+1
            do 30 ic = 1, ndim
                icdiag=ic*(ic-1)/2+1
                if (ic .ge. il) then
                    ctrav1=ctrav1+(ca(icdiag+ic-il)*cvec(ic))
                    ctrav2=ctrav2+(ca(icdiag+ic-il)*cbas(ic,j))
                else
                    ctrav1=ctrav1+(dconjg(ca(ildiag+il-ic))*cvec(ic))
                    ctrav2=ctrav2+(dconjg(ca(ildiag+il-ic))*cbas(ic,j)&
                    )
                endif
30          continue
            call zconju(cbas(il, j), prea, pima)
            cconj=dcmplx(prea,-pima)
            cprod=cprod+(ctrav1*cconj)
            cmodu=cmodu+(ctrav2*cconj)
20      continue
!
!
!
!   ORTHOGONALISATION DE SCHMIT (LE POTE DE GRAM)
!
        do 40 i = 1, ndim
            cvec(i)=cvec(i)-(cprod*cbas(i,j)/cmodu)
40      continue
!
10  end do
!
    call cvnorm(ca, cvec, ndim, iretou)
    if (iretou .eq. 1) then
        call utmess('F', 'ALGORITH2_22')
    endif
!
!
!
9999  continue
end subroutine
