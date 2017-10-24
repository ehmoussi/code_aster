subroutine lgicfc(ndim, nno1, nno2, npg, nddl, axi,grand,&
                  geoi,ddlm, vff1, vff2, idfde1, idfde2,&
                  iw, sigmag,fint)
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
#include "asterfort/nmepsi.h"
#include "blas/dcopy.h"
#include "blas/daxpy.h"
#include "blas/dscal.h"
#include "blas/dgemv.h"
#include "blas/ddot.h"
    aster_logical :: axi,grand
    integer :: ndim, nno1, nno2, npg, idfde1, idfde2, iw
    real(kind=8) ::vff1(nno1, npg), vff2(nno2, npg)
    integer :: nddl,neps,nepg
    real(kind=8) :: b(3*ndim+4, npg, nddl),sigmag(3*ndim+2,npg),sigfint(3*ndim+4,npg)
    real(kind=8) :: w(npg),wdef(npg),bv((3*ndim+4)* npg* nddl,1),sigfintv((3*ndim+4)*npg,1)
    real(kind=8) ::  geom(ndim*nno1), ddlm(nddl),geoi(ndim*nno1),depl(ndim*nno1)
! ----------------------------------------------------------------------
!  CALCUL DES ELEMENTS CINEMATIQUES POUR LA MODELISATION GRAD_VARI_INCO
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
    integer :: g,n,i,kl
    real(kind=8) :: rac2, r2, r, dfdi1(27*3), dfdi2(8*3), unsurr, gm, pm, jm
    real(kind=8) :: tauhy, taufint(6), kr(6), tau(6),fint(nddl)
    real(kind=8) :: presm(nno2),gonfm(nno2),fm(3,3),epsm(6)
! ----------------------------------------------------------------------
#define    iu1(n,i)  (n-1)*(ndim+4) + i
#define    iu2(n,i)  nno2*4 + (n-1)*ndim + i

#define    ip(n)  (n-1)*(ndim+4) + ndim + 1
#define    ig(n)  (n-1)*(ndim+4) + ndim + 2
#define    ia(n)  (n-1)*(ndim+4) + ndim + 3
#define    il(n)  (n-1)*(ndim+4) + ndim + 4
#define    dff1(n,i)  dfdi1(nno1*(i-1) + n)
#define    dff2(n,i)  dfdi2(nno2*(i-1) + n)

    data         kr   / 1.d0, 1.d0, 1.d0, 0.d0, 0.d0, 0.d0/
! ----------------------------------------------------------------------
    ASSERT(nno1.le.27)
    ASSERT(nno2.le.8)
    rac2 = sqrt(2.d0)
    r2 = sqrt(2.d0)/2
    taufint = 0.0
    tau =0.0
    presm = 0.0
    gonfm = 0.0
    geom = 0.0
    neps = 3*ndim + 4
    nepg = neps*npg

    call r8inir(nepg*nddl, 0.d0, b, 1)
    call dcopy(ndim*nno1, geoi, 1, geom, 1)

    if (grand) then
        do 4 n = 1, nno2
            call dcopy(ndim, ddlm((ndim+4)*(n-1)+1), 1, depl(ndim*(n-1)+1), 1)
            presm(n) = ddlm((ndim+4)*(n-1)+ndim+1)       
            gonfm(n) = ddlm((ndim+4)*(n-1)+ndim+2)
4       end do
        call dcopy(ndim*(nno1-nno2), ddlm((ndim+4)*nno2+1), 1, depl(ndim*nno2+1), 1)
        call daxpy(ndim*nno1, 1.d0, depl, 1, geom,1)
    end if



! - AFFECTATION DE LA MATRICE CINEMATIQUE B

    do 1000 g = 1, npg

        call dfdmip(ndim, nno2, axi, geoi, g,iw, vff2(1, g), idfde2, r, w(g), dfdi2)

        call dfdmip(ndim, nno1, axi, geoi, g,iw, vff1(1, g), idfde1, r, w(g), dfdi1)

        call nmepsi(ndim, nno1, axi, grand, vff1(1,g), r, dfdi1, depl, fm, epsm)

        call dfdmip(ndim, nno1, axi, geom, g, iw, vff1(1, g), idfde1, r, wdef(g),dfdi1)

        jm = fm(1,1)*(fm(2,2)*fm(3,3)-fm(2,3)*fm(3,2))&
           - fm(2,1)*(fm(1,2)*fm(3,3)-fm(1,3)*fm(3,2))&
           + fm(3,1)*(fm(1,2)*fm(2,3)-fm(1,3)*fm(2,2))



! - CALCUL DE LA PRESSION ET DU GONFLEMENT
        gm = ddot(nno2,vff2(1,g),1,gonfm,1)
        pm = ddot(nno2,vff2(1,g),1,presm,1)

! 	write (6,*) 'LGICFC Point de Gauss ',g,w(g)
! 	write (6,*) 'LGICFC JM = ',jm,log(jm)
! 	write (6,*) 'LGICFC gm = ',gm
! 	write (6,*) 'LGICFC pm = ',pm


        tau(1:2*ndim) = sigmag(1:2*ndim,g)*jm
        tauhy = (tau(1)+tau(2)+tau(3))/3.d0
        do kl = 1, 6
            taufint(kl) = tau(kl) + (pm- tauhy)*kr(kl)
        end do
        do 5 i = 4, 2*ndim
            taufint(i) = taufint(i)*rac2
 5      end do

        sigfint(1:2*ndim,g) = taufint(1:2*ndim)
        sigfint(2*ndim+1,g) = log(jm) - gm
        sigfint(2*ndim+2,g) = tauhy - pm
        sigfint(2*ndim+3:3*ndim+4,g) = sigmag(2*ndim+1:3*ndim+2,g)

        if (ndim .eq. 2) then
            if (axi) then
                unsurr = 1/r
            else
                unsurr = 0
            endif
!
            do 10 n = 1, nno2
                b(1,g,iu1(n,1)) = dff1(n,1)
                b(2,g,iu1(n,2)) = dff1(n,2)
                b(3,g,iu1(n,1)) = vff1(n,g)*unsurr
                b(4,g,iu1(n,1)) = r2*dff1(n,2)
                b(4,g,iu1(n,2)) = r2*dff1(n,1)
                b(5,g,ip(n)) = vff2(n,g)
                b(6,g,ig(n)) = vff2(n,g)
                b(7,g,ia(n)) = vff2(n,g)
                b(8,g,il(n)) = vff2(n,g)
                b(9,g,ia(n)) = dff2(n,1)
                b(10,g,ia(n)) = dff2(n,2)
10          continue
!
            do 20 n = nno2+1, nno1
                b(1,g,iu2(n,1)) = dff1(n,1)
                b(2,g,iu2(n,2)) = dff1(n,2)
                b(3,g,iu2(n,1)) = vff1(n,g)*unsurr
                b(4,g,iu2(n,1)) = r2*dff1(n,2)
                b(4,g,iu2(n,2)) = r2*dff1(n,1)
20          continue
!
        else if (ndim.eq.3) then
            do 30 n = 1, nno2
                b(1,g,iu1(n,1)) = dff1(n,1)
                b(2,g,iu1(n,2)) = dff1(n,2)
                b(3,g,iu1(n,3)) = dff1(n,3)
                b(4,g,iu1(n,1)) = r2*dff1(n,2)
                b(4,g,iu1(n,2)) = r2*dff1(n,1)
                b(5,g,iu1(n,1)) = r2*dff1(n,3)
                b(5,g,iu1(n,3)) = r2*dff1(n,1)
                b(6,g,iu1(n,2)) = r2*dff1(n,3)
                b(6,g,iu1(n,3)) = r2*dff1(n,2)
                b(7,g,ip(n)) = vff2(n,g)
                b(8,g,ig(n)) = vff2(n,g)
                b(9,g,ia(n)) = vff2(n,g)
                b(10,g,il(n)) = vff2(n,g)
                b(11,g,ia(n)) = dff2(n,1)
                b(12,g,ia(n)) = dff2(n,2)
                b(13,g,ia(n)) = dff2(n,3)
30          continue
!
            do 40 n = nno2+1, nno1
                b(1,g,iu2(n,1)) = dff1(n,1)
                b(2,g,iu2(n,2)) = dff1(n,2)
                b(3,g,iu2(n,3)) = dff1(n,3)
                b(4,g,iu2(n,1)) = r2*dff1(n,2)
                b(4,g,iu2(n,2)) = r2*dff1(n,1)
                b(5,g,iu2(n,1)) = r2*dff1(n,3)
                b(5,g,iu2(n,3)) = r2*dff1(n,1)
                b(6,g,iu2(n,2)) = r2*dff1(n,3)
                b(6,g,iu2(n,3)) = r2*dff1(n,2)
40          continue
        endif
1000  end do

    do 2000 g = 1, npg
        sigfint(1:neps,g) = sigfint(1:neps,g)*w(g)
2000  end do

    call dgemv('T', nepg, nddl, 1.d0, b,&
               nepg, sigfint, 1, 0.d0, fint,&
               1)


end subroutine
