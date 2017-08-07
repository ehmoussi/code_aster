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
! aslint: disable=W1504
!
subroutine xmathm(jmate, thmc, hydr, t, ndim,&
                  nnops, nnop, nddls, nddlm, ffc,&
                  pla, nd, jac, ffp, ffp2, dt, ta, saut,&
                  dffc, rho11, gradpf, mmat,&
                  dsidep, p, r, jheavn, ncompn, ifiss,&
                  nfiss, nfh, ifa, jheafa, ncomph)

    implicit none
    
#include "asterfort/xmmatc.h"
#include "asterfort/xmmatb.h"
#include "asterfort/xmmatu.h"
#include "asterfort/xmmata.h"
#include "asterfort/thmlec.h"  
 
! person_in_charge: daniele.colombo at ifpen.fr
! ======================================================================
!
! ROUTINE MODELE HM-XFEM (CAS DE LA FRACTURE)
!
! CALCUL DE LA MATRICE MMAT
!
! ----------------------------------------------------------------------
!
    integer :: nnops, nnop, nddls, nddlm, ndim, pla(27)
    integer :: jheavn, ncompn, nfiss, ifiss, nfh, ifa, jheafa, ncomph
    real(kind=8) :: ffc(16), nd(3), jac, ffp(27)
    real(kind=8) :: ffp2(27), mmat(560,560), dt, ta, saut(3)
    real(kind=8) :: dffc(16, 3), unsurk, rho11, viscl
    real(kind=8) :: gradpf(3), dsidep(6,6), p(3,3), r
!
    integer :: jmate
    real(kind=8) :: rbid1, rbid2, rbid3, rbid4, rbid5, rbid6, rbid7
    real(kind=8) :: rbid9, rbid10, rbid11(3), rbid12(3,3)
    real(kind=8) :: rbid13, rbid14, rbid15, rbid16, rbid17, rbid18
    real(kind=8) :: rbid19, rbid20, rbid21, rbid22, rbid23, rbid24
    real(kind=8) :: rbid25, rbid26, rbid27, rbid28(3,3), rbid29(3,3) 
    real(kind=8) :: rbid30, rbid31, rbid32, rbid33, rbid34, rbid35(3,3)
    real(kind=8) :: rbid37, rbid38(3), t, rbid8(6)
    character(len=16) :: thmc, hydr, zkbid
!
    zkbid = 'VIDE'
!
    call thmlec(jmate, thmc, hydr, zkbid,&
                t, rbid1, rbid2, rbid3, rbid4,&
                rbid5, rbid6, rbid7, rbid8, rbid9,&
                rbid10, rbid11, rbid12, rbid13, rbid14,&
                rbid15, rbid16, rbid17, rbid18, rbid19,&
                rbid20, rbid21, rbid22, unsurk, rbid23,&
                rbid24, rbid25, viscl, rbid26, rbid27,&
                rbid28, rbid29, rbid30, rbid31, rbid32,&
                rbid33, rbid34, rbid35, rbid37,&
                rbid38, ndim)
!
    call xmmatu(ndim, nnop, nnops, nddls, nddlm, pla,&
                dsidep, p, r, ffp, jac, ffc, nd, mmat,&
                jheavn, ncompn, ifiss, nfiss, nfh, ifa,&
                jheafa, ncomph)
!
    call xmmatc(ndim, nnops, nddls, nddlm, ffc,&
                pla, jac, ffp2, mmat,&
                jheavn, ncompn, ifiss, nfiss,&
                nfh, ifa, jheafa, ncomph)
!
    call xmmatb(ndim, nnops, nddls, nddlm, ffc,&
                pla, dt, ta, jac, ffp2, mmat,&
                jheavn, ncompn, ifiss, nfiss, nfh,&
                ifa, jheafa, ncomph)
!
    call xmmata(ndim, nnops, nnop, nddls, nddlm, saut,&
                nd, pla, ffc, dffc, mmat, rho11, viscl,&
                gradpf, ffp, dt, ta, jac,&
                unsurk, jheavn, ncompn, ifiss, nfiss,&
                nfh, ifa, jheafa, ncomph)
!
end subroutine
