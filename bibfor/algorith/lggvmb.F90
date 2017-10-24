subroutine lggvmb(ndim, nno1, nno2, npg, g,axi,r,&
                  bst, vff2, dfdi2, nddl,&
                  neps, b, w)
! ======================================================================
! COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dfdmip.h"
#include "asterfort/r8inir.h"
    aster_logical :: axi
    integer :: ndim, nno1, nno2, npg,g
    real(kind=8) :: vff2(nno2)
    integer :: nddl, neps
    real(kind=8) :: b(3*ndim+2,nddl),bst(6,nno1*ndim)
    real(kind=8) :: w
! ----------------------------------------------------------------------
!  CALCUL DES ELEMENTS CINEMATIQUES POUR LA MODELISATION GRAD_VARI
! ----------------------------------------------------------------------
! IN  NDIM   DIMENSION DE L'ESPACE
! IN  NNO1   NOMBRE DE NOEUDS TOTAL (SUPPORT DES DEPLACEMENTS)
! IN  NNO2   NOMBRE DE NOEUDS SOMMETS (SUPPORT DE VI ET LAGRANGE)
! IN  NPG    NOMBRE DE POINTS DE GAUSS
! IN  AXI    .TRUE. SI MODELISATION AXIS
! IN  GEOM   COORDONNEES DES NOEUDS
! IN  VFF1   VALEUR DE LA FAMILLE DE FONCTIONS DE FORME NO 1
! IN  VFF2   VALEUR DE LA FAMILLE DE FONCTIONS DE FORME NO 2
! IN  IDFDE1 POINTEUR SUR LES DER. REFERENCE FAMILLE FCT FORME NO 1
! IN  IDFDE2 POINTEUR SUR LES DER. REFERENCE FAMILLE FCT FORME NO 2
! IN  IW     POINTEUR SUR LES POIDS DES PTS DE GAUSS DE REFERENCE
! OUT NDDL   NOMBRE DE DDL / ELEMENT
! OUT NEPS   NBR DE COMPOSANTE DE DEFORMATION (GENERALISEE)
! OUT B      MATRICE CINEMATIQUE EPS = B.U
! OUT W      POIDS DES POINTS DE GAUSS REELS
! OUT NI2LDC CONVERSION CONTRAINTE STOCKEE -> CONTRAINTE LDC (AVEC RAC2)
! ----------------------------------------------------------------------
    real(kind=8) :: rac2, r2, r, unsurr
! ----------------------------------------------------------------------
    integer :: iu1, iu2, iub,ia, il, n, i, idfde2
    real(kind=8) :: dff1, dff2,dfdi2(nno2*ndim)
    iu1(n,i) = (n-1)*(ndim+2) + i
    iu2(n,i) = nno2*2 + (n-1)*ndim + i
    iub(n,i) = (n-1)*ndim + i
    ia(n) = (n-1)*(ndim+2) + ndim + 1
    il(n) = (n-1)*(ndim+2) + ndim + 2
!     dff1(n,i) = dfdi1(nno1*(i-1) + n)
    dff2(n,i) = dfdi2(nno2*(i-1) + n)
! ----------------------------------------------------------------------
    ASSERT(nno1.le.27)
    ASSERT(nno2.le.8)
    rac2 = sqrt(2.d0)
    r2 = sqrt(2.d0)/2
    nddl = nno1*ndim + nno2*2
    neps = 3*ndim + 2
    b=0.
!
! - AFFECTATION DE LA FONCTION DE TRANSFERT SIGMA NICE --> SIGMA LDC
!
        if (ndim .eq. 2) then
            if (axi) then
                unsurr = 1./r
            else
                unsurr = 0.
            endif
!
            do 10 n = 1, nno2
                do 11 i = 1, 2
                    b(1,iu1(n,i)) = bst(1,iub(n,i))
                    b(2,iu1(n,i)) = bst(2,iub(n,i))
                    b(3,iu1(n,i)) = bst(3,iub(n,i))
                    b(4,iu1(n,i)) = bst(4,iub(n,i))
11              continue

                b(5,ia(n)) = vff2(n)
                b(6,il(n)) = vff2(n)
                b(7,ia(n)) = dff2(n,1)
                b(8,ia(n)) = dff2(n,2)

10          continue
            
            do 20 n = nno2+1, nno1
                do 21 i =1, 2
                    b(1,iu2(n,i)) = bst(1,iub(n,i))
                    b(2,iu2(n,i)) = bst(2,iub(n,i))
                    b(3,iu2(n,i)) = bst(3,iub(n,i))
                    b(4,iu2(n,i)) = bst(4,iub(n,i))
21              continue
20          continue
!           print*, 'bst=', bst(1:6,1)

        else if (ndim.eq.3) then
            do 30 n = 1, nno2
                do 31 i = 1, 3
                    b(1,iu1(n,i)) = bst(1,iub(n,i))
                    b(2,iu1(n,i)) = bst(2,iub(n,i))
                    b(3,iu1(n,i)) = bst(3,iub(n,i))
                    b(4,iu1(n,i)) = bst(4,iub(n,i))
                    b(5,iu1(n,i)) = bst(5,iub(n,i))
                    b(6,iu1(n,i)) = bst(6,iub(n,i))
31              continue
                b(7,ia(n)) = vff2(n)
                b(8,il(n)) = vff2(n)
                b(9,ia(n)) = dff2(n,1)
                b(10,ia(n)) = dff2(n,2)
                b(11,ia(n)) = dff2(n,3)

30          continue
!
            do 40 n = nno2+1, nno1
                do 41 i=1,3
                    b(1,iu2(n,i)) = bst(1,iub(n,i))
                    b(2,iu2(n,i)) = bst(2,iub(n,i))
                    b(3,iu2(n,i)) = bst(3,iub(n,i))
                    b(4,iu2(n,i)) = bst(4,iub(n,i))
                    b(5,iu2(n,i)) = bst(5,iub(n,i))
                    b(6,iu2(n,i)) = bst(6,iub(n,i))
41              continue
40          continue
        endif


end subroutine
