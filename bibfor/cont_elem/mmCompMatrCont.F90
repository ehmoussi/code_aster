! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine mmCompMatrCont(phase    , l_pena_cont, i_reso_geom, &
                          nbdm     , &
                          ndim     , nne        , nnm   , nnl   ,&
                          wpg      , jacobi     , coefac,&
                          jeu      , dlagrc     ,&
                          ffe      , ffm        , ffl   , dffm  ,&
                          norm     , mprojn     ,&
                          mprt1n   , mprt2n     , mprnt1, mprnt2,&
                          mprt11   , mprt12     , mprt21, mprt22,&
                          kappa    , vech1      , vech2 ,&
                          h        , hah        , &
                          matr_cont)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mmmtas.h"
#include "asterfort/mmgnuu.h"
#include "Contact_type.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont
integer, intent(in) :: i_reso_geom
integer, intent(in) :: nbdm
integer, intent(in) :: ndim, nne, nnm, nnl
real(kind=8), intent(in) :: wpg, jacobi, coefac
real(kind=8), intent(in) :: ffe(9), ffm(9), ffl(9), dffm(2, 9)
real(kind=8), intent(in) :: norm(3), mprojn(3, 3)
real(kind=8), intent(in) :: jeu, dlagrc
real(kind=8), intent(in) :: mprt1n(3,3), mprt2n(3,3), mprnt1(3,3), mprnt2(3,3)
real(kind=8), intent(in) :: mprt11(3,3), mprt12(3,3), mprt21(3,3), mprt22(3,3)
real(kind=8), intent(in) :: kappa(2,2), vech1(3), vech2(3), h(2,2), hah(2,2)
real(kind=8), intent(inout) :: matr_cont(81, 81)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for contact
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'CONT' - Contact
! In  l_pena_cont      : flag for penalized contact
! In  i_reso_geom      : algorithm for geometry
! In  nbdm             : number of components by node for all dof
! In  ndim             : dimension of problem (2 or 3)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  jeu              : normal gap
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  ffl              : shape function for Lagrange dof
! In  dffm             : first derivative of shape function for master nodes
! In  norm             : normal at current contact point
! In  mprojn           : matrix of normal projection
! In  mprt1n           : projection matrix first tangent/normal
! In  mprt2n           : projection matrix second tangent/normal
! In  mprnt1           : projection matrix normal/first tangent
! In  mprnt2           : projection matrix normal/second tangent
! In  mprt11           : projection matrix first tangent/first tangent
!                        tau1*TRANSPOSE(tau1)(matrice 3*3)
! In  mprt12           : projection matrix first tangent/second tangent
!                        tau1*TRANSPOSE(tau2)(matrice 3*3)
! In  mprt21           : Projection matrix second tangent/first tangent
!                        tau2*TRANSPOSE(tau1)(matrice 3*3)
! In  mprt22           : Projection matrix second tangent/second tangent
!                        tau2*TRANSPOSE(tau2)(matrice 3*3)
! In  kappa            : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
!                        KAPPA(i,j) = INVERSE[tau_i.tau_j-JEU*(ddFFM*geomm)](matrice 2*2)
! In  vech1            : KAPPA(1,m)*tau_m
! In  vech2            : KAPPA(2,m)*tau_m
! In  h                : MATRICE DE SCALAIRES EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
!                        H(i,j) = JEU*{[DDGEOMM(i,j)].n} (matrice 2*2)
! In  hah              : HA/H  (matrice 2*2)
! IO  matr_cont        : matrix for contact
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: matrcc(9, 9), matree(27, 27), matrmm(27, 27)
    real(kind=8) :: matrem(27, 27), matrme(27, 27), matrce(9, 27), matrcm(9, 27)
    real(kind=8) :: matrec(27, 9), matrmc(27, 9)
    integer :: inoc, inoe, inom, idim, inoc1, inoc2
    integer :: i, j, k, l, ii, jj, nbcps
    character(len=4) :: phase_cont
!
! --------------------------------------------------------------------------------------------------
!
    matrcc(:, :) = 0.d0
    matree(:, :) = 0.d0
    matrmm(:, :) = 0.d0
    matrem(:, :) = 0.d0
    matrme(:, :) = 0.d0
    matrec(:, :) = 0.d0
    matrmc(:, :) = 0.d0
    matrce(:, :) = 0.d0
    matrcm(:, :) = 0.d0
!
    phase_cont = phase
    if (phase .eq. 'ADHE' .or. phase .eq. 'GLIS') then
        phase_cont = 'CONT'
    endif
!
! - MATR_UU
!
    if (phase_cont .eq. 'CONT' .or. (phase .eq. 'NCON')) then
        do i = 1, nne
            do j = 1, nne
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matree(ii,jj) = matree(ii,jj) +&
                                        coefac*wpg*jacobi*ffe(i)*mprojn(l,k)*ffe(j)
                    end do
                end do
            end do
        end do
        do i = 1, nnm
            do j = 1, nnm
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrmm(ii,jj) = matrmm(ii,jj) +&
                                        coefac*wpg*jacobi*ffm(i)*mprojn(l,k)*ffm(j)
                    end do
                end do
            end do
        end do
        do i = 1, nnm
            do j = 1, nne
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrme(ii,jj) = matrme(ii,jj) -&
                                        coefac*wpg*jacobi*ffm(i)*mprojn(l,k)*ffe(j)
                    end do
                end do
            end do
        end do
        do i = 1, nne
            do j = 1, nnm
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrem(ii,jj) = matrem(ii,jj) -&
                                        coefac*wpg*jacobi*ffe(i)*mprojn(l,k)*ffm(j)
                    end do
                end do
            end do
        end do
    endif
!
! - Non-linear geometric contribution
!
    if (phase_cont .eq. 'CONT') then
        if (i_reso_geom .eq. ALGO_NEWT) then
            call mmgnuu(ndim  , nne   , nnm   ,&
                        wpg   , ffe   , ffm   , dffm  ,&
                        jacobi, coefac, jeu   , dlagrc,&
                        mprojn,&
                        mprt1n, mprt2n, mprnt1, mprnt2,&
                        mprt11, mprt12, mprt21, mprt22,&
                        kappa , vech1 , vech2 ,&
                        h     , hah   , &
                        matree, matrmm, matrem, matrme)
        endif
    endif
!
! - MATR_EC and MATR_MC
!
    if (phase_cont .eq. 'CONT' .or. phase_cont .eq. 'NCON') then
        if (.not. l_pena_cont) then
            do inoc = 1, nnl
                do inoe = 1, nne
                    do idim = 1, ndim
                        jj = ndim*(inoe-1)+idim
                        matrec(jj,inoc) = matrec(jj,inoc) -&
                                          wpg*ffl(inoc)*ffe(inoe)*jacobi*norm(idim)
                    end do
                end do
            end do
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
    endif
!
! - MATR_CC
!
    if (phase_cont .eq. 'SANS') then
        do inoc1 = 1, nnl
            do inoc2 = 1, nnl
                matrcc(inoc1,inoc2) = matrcc(inoc1,inoc2)-&
                                      wpg*jacobi/coefac*ffl(inoc2)*ffl(inoc1)
            end do
        end do
    endif
    if (phase_cont .eq. 'NCON' .and. l_pena_cont) then
        do inoc1 = 1, nnl
            do inoc2 = 1, nnl
                matrcc(inoc1,inoc2) = matrcc(inoc1,inoc2)-&
                                      wpg*jacobi/coefac*ffl(inoc2)*ffl(inoc1)
            end do
        end do
    endif
!
! - MATR_CC
!
    if (phase_cont .eq. 'CONT') then
        if (l_pena_cont) then
            do inoc1 = 1, nnl
                do inoc2 = 1, nnl
                    matrcc(inoc1,inoc2) = matrcc(inoc1,inoc2)-&
                                          wpg*jacobi/coefac*ffl(inoc2)*ffl(inoc1)
                end do
            end do
        endif
    endif
!
! - MATR_CE and MATR_CM
!
    if (phase_cont .eq. 'CONT'.or. phase_cont .eq. 'NCON') then
        do inoc = 1, nnl
            do inoe = 1, nne
                do idim = 1, ndim
                    jj = ndim*(inoe-1)+idim
                    matrce(inoc,jj) = matrce(inoc,jj) -&
                                      wpg*ffl(inoc)*ffe(inoe)*jacobi*norm(idim)
                end do
            end do
        end do
        do inoc = 1, nnl
            do inom = 1, nnm
                do idim = 1, ndim
                    jj = ndim*(inom-1)+idim
                    matrcm(inoc,jj) = matrcm(inoc,jj) +&
                                      wpg*ffl(inoc)*ffm(inom)*jacobi*norm(idim)
                end do
            end do
        end do
    endif
!
! - Assembling (no friction here => nbcps = 0)
!
    nbcps = 0
    call mmmtas(nbdm     , ndim  , nnl   , nne   , nnm   , nbcps,&
                matrcc   , matree, matrmm, matrem,&
                matrme   , matrce, matrcm, matrmc, matrec,&
                matr_cont)
!
end subroutine
