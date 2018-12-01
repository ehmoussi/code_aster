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

subroutine xmvef2(ndim, nno, nnos, ffp, jac,&
                  seuil, reac12, singu, fk, nfh,&
                  coeffp, coeffr, mu, algofr, nd,&
                  ddls, ddlm, idepl, pb, vtmp)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/indent.h"
#include "asterfort/vecini.h"
#include "asterfort/xadher.h"
#include "asterfort/xmafr1.h"
#include "asterfort/xcalc_saut.h"
integer :: ndim, nno, nnos, ddls, ddlm, nfh, singu, idepl
integer :: algofr
real(kind=8) :: vtmp(400), nd(3)
real(kind=8) :: ffp(27), jac, pb(3), reac12(3)
real(kind=8) :: coeffp, coeffr, seuil, mu
real(kind=8) :: fk(27,3,3)
!
!
!
! ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
!
! --- CALCUL DU VECTEUR LN1
!
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT DE REF PARENT
! IN  NNOS   : NOMBRE DE NOEUDS SOMMET DE L'ELEMENT DE REF PARENT
! IN  NNOL   : NOMBRE DE NOEUDS PORTEURS DE DDLC
! IN  NNOF   : NOMBRE DE NOEUDS DE LA FACETTE DE CONTACT
! IN  PLA    : PLACE DES LAMBDAS DANS LA MATRICE
! IN  IPGF   : NUMÉRO DU POINTS DE GAUSS
! IN  IVFF   : ADRESSE DANS ZR DU TABLEAU FF(INO,IPG)
! IN  FFC    : FONCTIONS DE FORME DE L'ELEMENT DE CONTACT
! IN  FFP    : FONCTIONS DE FORME DE L'ELEMENT PARENT
! IN  IDEPD  :
! IN  IDEPM  :
! IN  NFH    : NOMBRE DE FONCTIONS HEAVYSIDE
! IN  MALIN  : INDICATEUR FORMULATION (T=NOEUDS , F=ARETE)
! IN  TAU1   : TANGENTE A LA FACETTE AU POINT DE GAUSS
! IN  TAU2   : TANGENTE A LA FACETTE AU POINT DE GAUSS
! IN  SINGU  : 1 SI ELEMENT SINGULIER, 0 SINON
! IN  RR     : DISTANCE AU FOND DE FISSURE
! IN  IFA    : INDICE DE LA FACETTE COURANTE
! IN  CFACE  : CONNECTIVITÉ DES NOEUDS DES FACETTES
! IN  LACT   : LISTE DES LAGRANGES ACTIFS
! IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) À CHAQUE NOEUD SOMMET
! IN  DDLM   : NOMBRE DE DDL A CHAQUE NOEUD MILIEU
! IN  COEFFR : COEFFICIENT D AUGMENTATION DU FROTTEMENT
! IN  COEFFP : COEFFICIENT DE PENALISATION DU FROTTEMENT
! IN  ALGOFR : ALGO DE FROTTEMENT (1:LAG, 2:PENALISATION)
! IN  P      :
! OUT ADHER  :
! OUT KNP    : PRODUIT KN.P
! OUT PTKNP  : MATRICE PT.KN.P
! OUT IK     :
!
!
!
!
    integer :: i, j, k, in, ino, ig
    integer :: alpi
    real(kind=8) :: ptpb(3), p(3, 3), vitang(3), saut(3), rbid(3, 3)
    real(kind=8) :: r2bid(3, 3)
    real(kind=8) :: r3bid(3, 3), coefj
    aster_logical :: adher
!
! ----------------------------------------------------------------------
!
    coefj=xcalc_saut(1,0,1)
!
!     P : OPÉRATEUR DE PROJECTION
    call xmafr1(ndim, nd, p)
!
!     PBOUL SELON L'ÉTAT D'ADHERENCE DU PG (AVEC DEPDEL)
    call vecini(3, 0.d0, saut)
    do ino = 1, nno
        call indent(ino, ddls, ddlm, nnos, in)
        do j = 1, ndim
            do ig = 1, nfh          
                saut(j) = saut(j) - coefj * ffp(ino) * zr(idepl-1+in+ndim*(1+ig-1)+ j)
            enddo
        end do
        do j = 1, singu*ndim
            do alpi = 1, ndim
                saut(j) = saut(j) - 2.d0 * fk(ino,alpi,j) * &
                                            zr(idepl-1+in+ndim*(1+nfh)+alpi)
            enddo
        end do
    end do
!
    call xadher(p, saut, reac12, coeffr, coeffp,&
                algofr, vitang, pb, rbid, r2bid,&
                r3bid, adher)
!
    if (adher) then
!               CALCUL DE PT.REAC12
        do i = 1, ndim
            ptpb(i)=0.d0
            if (algofr .eq. 2) then
                do k = 1, ndim
                    ptpb(i)=ptpb(i)+p(k,i)*coeffp*vitang(k)
                end do
            else
                do k = 1, ndim
                    ptpb(i)=ptpb(i)+p(k,i)*(reac12(k)+coeffr*vitang(k))
                end do
            endif
        end do
    else
!     CALCUL DE PT.PBOUL
        do i = 1, ndim
            ptpb(i)=0.d0
            do k = 1, ndim
                ptpb(i)=ptpb(i) + p(k,i)*pb(k)
            end do
        end do
    endif
!
    do i = 1, nno
        call indent(i, ddls, ddlm, nnos, in)
        do j = 1, ndim
            do ig = 1, nfh        
                vtmp(in+ndim*(1+ig-1)+j) = vtmp(in+ndim*(1+ig-1)+j) +&
                                           coefj*mu*seuil*ptpb(j)*ffp(i)*jac
            enddo
        end do
        do j = 1, singu*ndim
            do alpi = 1, ndim
                vtmp(in+ndim*(1+nfh)+alpi) = vtmp(in+ndim*(1+nfh)+alpi) +&
                                             2.d0*fk(i,alpi,j)*mu*seuil* ptpb(j)*jac
            enddo
        end do
    end do
!
end subroutine
