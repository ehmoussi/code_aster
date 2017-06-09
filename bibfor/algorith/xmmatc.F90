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

subroutine xmmatc(ndim, nnops, ddls, ddlm, ffc,&
                  pla, jac, ffp2, mmat,&
                  jheavn, ncompn, ifiss, nfiss,&
                  nfh, ifa, jheafa, ncomph)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/hmdeca.h"
#include "asterfort/xcalc_code.h"
#include "asterfort/xcalc_heav.h"
! person_in_charge: daniele.colombo at ifpen.fr
! ======================================================================
!
! ROUTINE MODELE HM-XFEM 
!
! CALCUL DE LA MATRICE MMAT (CONTINUITE DE LA PRESSION)
!
! ----------------------------------------------------------------------
!
    integer :: i, j, ndim, nnops, in, ddls, ddlm
    integer :: jheavn, ncompn, nfiss, heavn(nnops, ncompn)
    integer :: plj, pla(27), pli, hea_fa(2), dec
    integer :: ifiss, nfh, jheafa, ifa, ncomph, ifh
    real(kind=8) :: ffj, ffc(16), ffi
    real(kind=8) :: jac, ffp2(27), mmat(560,560)
    aster_logical :: lmultc
!
    lmultc = nfiss.gt.1
    if (.not.lmultc) then
      hea_fa(1)=xcalc_code(1,he_inte=[-1])
      hea_fa(2)=xcalc_code(1,he_inte=[+1])
    else
      hea_fa(1) = zi(jheafa-1+ncomph*(ifiss-1)+2*(ifa-1)+1)
      hea_fa(2) = zi(jheafa-1+ncomph*(ifiss-1)+2*(ifa-1)+2)
    endif
!
!     RECUPERATION DE LA DEFINITION DES DDLS HEAVISIDES
    do in = 1, nnops
      do i = 1 , ncompn
        heavn(in,i) = zi(jheavn-1+ncompn*(in-1)+i)
      enddo
    enddo
!
    do i = 1, nnops 
       ffi = ffc(i)
       pli = pla(i)
!
       do j = 1, nnops
          ffj = ffc(j)
          plj = pla(j)
!
          call hmdeca(j, ddls, ddlm, nnops, in, dec)  
!
          mmat(pli+1, in+ndim+1) = mmat(pli+1, in+ndim+1) + ffi*ffp2(j)*jac
!
          mmat(pli+2, in+ndim+1) = mmat(pli+2, in+ndim+1) + ffi*ffp2(j)*jac
!
          do ifh = 1, nfh
             mmat(pli+1,in+(ndim+1)*(ifh+1)) = mmat(pli+1,in+(ndim+1)*(ifh+1)) +&
                                     ffi*ffp2(j)*xcalc_heav(heavn(j,ifh),hea_fa(2),heavn(j,5))*jac
             mmat(pli+2,in+(ndim+1)*(ifh+1)) = mmat(pli+2,in+(ndim+1)*(ifh+1)) +&
                                     ffi*ffp2(j)*xcalc_heav(heavn(j,ifh),hea_fa(1),heavn(j,5))*jac
          end do
!
          mmat(pli+1, plj) = mmat(pli+1, plj) - ffi*ffj*jac
!
          mmat(pli+2, plj) = mmat(pli+2, plj) - ffi*ffj*jac
       end do 
    end do 
!
end subroutine
