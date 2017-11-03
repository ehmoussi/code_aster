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
! person_in_charge: daniele.colombo at ifpen.fr
! aslint: disable=W1504
!
subroutine xvechm(nnops, ddls, ddlm, ndim, pla,&
                  saut, sautm, nd, ffc, w11, w11m, jac,&
                  q1, dt, ta, q1m, ta1, q2, q2m, dffc,&
                  rho11, gradpf, rho11m, gradpfm, ffp2,&
                  vect, ffp,&
                  nnop, delta, lamb, am, r, p, psup,&
                  pinf, pf, ncompn, jheavn, ifiss, nfiss,&
                  nfh, ifa, jheafa, ncomph)
!
implicit none
!
#include "asterfort/xvecha.h"
#include "asterfort/xvechb.h"
#include "asterfort/xvechc.h"
#include "asterfort/xvechu.h"
!
! =====================================================================
!
!
! ROUTINE MODELE HM-XFEM
! 
! CALCUL DES SECONDS MEMBRES VECT
!
! ----------------------------------------------------------------------

    integer :: nnops, ddls, ddlm, ndim, pla(27), nnop
    integer :: ncompn, jheavn , nfiss, ncomph, ifiss, ifa, jheafa, nfh
    real(kind=8) :: saut(3), sautm(3), nd(3), ffc(16)
    real(kind=8) :: w11, w11m, jac, q1, dt, ta, q1m, ta1
    real(kind=8) :: q2, q2m, dffc(16, 3), rho11
    real(kind=8) :: gradpf(3), rho11m, gradpfm(3)
    real(kind=8) :: ffp2(27), vect(560), pf
    real(kind=8) :: pinf, psup, ffp(27), delta(6)
    real(kind=8) :: lamb(3), am(3), r, p(3,3)
!
!
    call xvecha(ndim, pla, nnops, saut,&
                sautm, nd, ffc, w11, w11m, jac,&
                q1, q1m, q2, q2m, dt, ta, ta1,&
                dffc, rho11, gradpf, rho11m,&
                gradpfm, vect)
!
    call xvechb(nnops, ddls, ddlm, ndim,&
                ffp2, q1, dt, ta, jac, q1m, ta1,&
                q2, q2m, vect, ncompn, jheavn, ifiss,&
                nfiss, nfh, ifa, jheafa, ncomph)
!
    call xvechc(nnops, pla, ffc, pinf,&
                pf, psup, jac, vect)
!
    call xvechu(ndim, nnop, nnops, ddls, ddlm, pla,&
                lamb, am, delta, r, p, ffp, jac, ffc, vect,&
                ncompn, jheavn, ifiss, nfiss,&
                nfh, ifa, jheafa, ncomph)
!
end subroutine                                      
