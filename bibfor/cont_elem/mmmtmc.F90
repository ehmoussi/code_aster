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
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1504
!
subroutine mmmtmc(phase , l_pena_cont, l_pena_fric,&
                  ndim  , nnl        , nnm        ,&
                  norm  , tau1       , tau2       , mprojt,&
                  wpg   , ffl        , ffm        , jacobi,&
                  coefff, coefaf     ,&
                  dlagrf, djeut      ,&
                  rese  , nrese      , matrmc)
!
implicit none
!
#include "asterf_types.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont, l_pena_fric
integer, intent(in) :: ndim, nnm, nnl
real(kind=8), intent(in) :: norm(3), tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: wpg, ffl(9), ffm(9), jacobi
real(kind=8), intent(in) :: coefff, coefaf
real(kind=8), intent(in) :: dlagrf(2), djeut(3)
real(kind=8), intent(in) :: rese(3), nrese
real(kind=8), intent(out) :: matrmc(27, 9)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for DOF [master x contact]
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_pena_cont      : flag for penalized contact
! In  l_pena_fric      : flag for penalized friction
! In  ndim             : dimension of problem (2 or 3)
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  nnm              : number of master nodes
! In  norm             : normal at current contact point
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  wpg              : weight for current Gauss point
! In  ffl              : shape function for Lagrange dof
! In  ffm              : shape function for master nodes
! In  jacobi           : jacobian at integration point
! In  coefff           : friction coefficient (Coulomb)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  djeut            : increment of tangent gaps
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! Out matrmc           : matrix for DOF [master x contact]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inoc, inom, idim, jj, i, j
    real(kind=8) :: dlagft(3), pdlaft(3), pdjeut(3), prese(3)
!
! --------------------------------------------------------------------------------------------------
!
    dlagft(:) = 0.d0
    pdlaft(:) = 0.d0
    pdjeut(:) = 0.d0
    prese(:)  = 0.d0
!
! - PROJECTION DU LAGRANGE DE FROTTEMENT SUR LE PLAN TANGENT
!
    if (phase .eq. 'ADHE') then
        dlagft(:) = dlagrf(1)*tau1(:)+dlagrf(2)*tau2(:)
    endif
!
! - PRODUIT LAGR. FROTTEMENT PAR MATRICE [Pt]
!
    if (phase .eq. 'ADHE') then
        do i = 1, ndim
            do j = 1, ndim
                pdlaft(i) = mprojt(i,j)*dlagft(j)+pdlaft(i)
            end do
        end do
    endif
!
! - PRODUIT INCREMENT DEPDEL DU JEU TANGENT PAR MATRICE [Pt]
!
    if (phase .eq. 'ADHE') then
        do i = 1, ndim
            do j = 1, ndim
                pdjeut(i) = mprojt(i,j)*djeut(j)+pdjeut(i)
            end do
        end do
    endif
!
! - PRODUIT SEMI MULT. LAGR. FROTTEMENT. PAR MATRICE P
!
    if (phase .eq. 'GLIS') then
        do i = 1, ndim
            do j = 1, ndim
                prese(i) = mprojt(i,j)*(rese(j)/nrese)+prese(i)
            end do
        end do
    endif
!
! - Part for contact
!
    if (.not. l_pena_cont) then
        do inoc = 1, nnl
            do inom = 1, nnm
                do idim = 1, ndim
                    jj = ndim*(inom-1)+idim
                    matrmc(jj,inoc) = matrmc(jj,inoc) +&
                                      wpg*ffl(inoc)*ffm(inom)*jacobi*norm(idim)
                end do
            end do
        end do
    endif
!
! - Part for friction
!
    if (phase .eq. 'ADHE') then
        if (.not. l_pena_fric) then
            do inoc = 1, nnl
                do inom = 1, nnm
                    do idim = 1, ndim
                        jj = ndim*(inom-1)+idim
                        matrmc(jj,inoc) = matrmc(jj,inoc) +&
                                          coefff*wpg*ffl(inoc)*ffm(inom)*jacobi*&
                                          (pdlaft(idim)+coefaf*pdjeut(idim))
                    end do
                end do
            end do
        endif
    else if (phase .eq. 'GLIS') then
        if (.not. l_pena_fric) then
            do inoc = 1, nnl
                do inom = 1, nnm
                    do idim = 1, ndim
                        jj = ndim*(inom-1)+idim
                        matrmc(jj,inoc) = matrmc(jj,inoc) +&
                                          coefff*wpg*ffl(inoc)*ffm(inom)*jacobi*prese(idim)
                    end do
                end do
            end do
        endif
    endif
!
end subroutine
