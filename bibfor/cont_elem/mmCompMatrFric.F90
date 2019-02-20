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
subroutine mmCompMatrFric(phase      , l_large_slip,&
                          l_pena_fric,&
                          i_reso_geom, i_reso_fric ,&
                          nbdm       , nbcps       , ndexfr,&
                          ndim       , nne         , nnm   , nnl   ,&
                          wpg        , jacobi      , coefac, coefaf,&
                          jeu        , dlagrc      ,&
                          ffe        , ffm         , ffl   , dffm  , ddffm,&
                          tau1       , tau2        , mprojt,&
                          rese       , nrese       , lambda, coefff,&
                          mprt1n     , mprt2n      , mprnt1, mprnt2,&
                          mprt11     , mprt12      , mprt21, mprt22,&
                          kappa      , vech1       , vech2 ,&
                          h          , &
                          dlagrf     , djeut ,&
                          matr_fric)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/mmmtas.h"
#include "asterfort/mmPrepMatrFric.h"
#include "asterfort/mmgtuu.h"
#include "asterfort/mmmtex.h"
#include "Contact_type.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_large_slip, l_pena_fric
integer, intent(in) :: i_reso_geom, i_reso_fric
integer, intent(in) :: nbdm, nbcps, ndexfr
integer, intent(in) :: ndim, nne, nnm, nnl
real(kind=8), intent(in) :: wpg, jacobi, coefac, coefaf
real(kind=8), intent(in) :: ffe(9), ffm(9), ffl(9), dffm(2,9), ddffm(3,9)
real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
real(kind=8), intent(in) :: rese(3), nrese, lambda, coefff
real(kind=8), intent(in) :: jeu, dlagrc
real(kind=8), intent(in) :: mprt1n(3,3), mprt2n(3,3), mprnt1(3,3), mprnt2(3,3)
real(kind=8), intent(in) :: mprt11(3,3), mprt12(3,3), mprt21(3,3), mprt22(3,3)
real(kind=8), intent(in) :: kappa(2,2), vech1(3), vech2(3), h(2,2)
real(kind=8), intent(in) :: dlagrf(2), djeut(3)
real(kind=8), intent(inout) :: matr_fric(81, 81)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute matrix for friction
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_large_slip     : flag for GRAND_GLISSEMENT
! In  l_pena_fric      : flag for penalized friction
! In  i_reso_geom      : algorithm for geometry
! In  i_reso_fric      : algorithm for friction
! In  ndexfr           : integer for EXCL_FROT_* keyword
! In  nbdm             : number of components by node for all dof
! In  nbcps            : number of components by node for Lagrange multiplicators
! In  ndim             : dimension of problem (2 or 3)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  wpg              : weight for current Gauss point
! In  jacobi           : jacobian at integration point
! In  coefac           : coefficient for updated Lagrangian method (contact)
! In  coefaf           : coefficient for updated Lagrangian method (friction)
! In  jeu              : normal gap
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  ffe              : shape function for slave nodes
! In  ffm              : shape function for master nodes
! In  ffl              : shape function for Lagrange dof
! In  dffm             : first derivative of shape function for master nodes
! In  ddffm            : second derivative of shape function for master nodes
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  mprojt           : matrix of tangent projection
! In  rese             : Lagrange (semi) multiplier for friction
! In  nrese            : norm of Lagrange (semi) multiplier for friction
! In  lambda           : contact pressure
! In  coefff           : friction coefficient (Coulomb)
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
! In  djeut            : increment of tangent gaps
! In  dlagrf           : increment of friction Lagrange from beginning of time step
! IO  matr_fric        : matrix for friction
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: matrcc(9, 9), matree(27, 27), matrmm(27, 27)
    real(kind=8) :: matrem(27, 27), matrme(27, 27), matrce(9, 27), matrcm(9, 27)
    real(kind=8) :: matrec(27, 9), matrmc(27, 9)
    real(kind=8) :: matref(27, 18), matrmf(27, 18)
    real(kind=8) :: matrff(18, 18), matrfe(18, 27), matrfm(18, 27)
    integer :: inoc, inoe, inof, inom, idim, nbcpf, icmp
    integer :: i, j, k, l, ii, jj
    real(kind=8) :: e(3, 3), a(2, 3), b(2, 3)
    real(kind=8) :: d(3, 3), r(2, 2), tt(3, 3)
    real(kind=8) :: dlagft(3), pdlaft(3), pdjeut(3), prese(3)
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
    matref(:, :) = 0.d0
    matrmf(:, :) = 0.d0
    matrfe(:, :) = 0.d0
    matrff(:, :) = 0.d0
    matrfm(:, :) = 0.d0
    nbcpf   = nbcps - 1
!
! - Prepare quantities for friction
!
    call mmPrepMatrFric(ndim  , nbcps ,&
                        tau1  , tau2  , mprojt,&
                        rese  , nrese ,&
                        dlagrf, djeut ,&
                        e     , a     ,&
                        b     , d     ,&
                        r     , tt    ,&
                        dlagft, pdlaft,&
                        pdjeut, prese)
!
! - MATR_EF
!
    if (phase .eq. 'ADHE') then
        if (.not. l_pena_fric) then
            do inof = 1, nnl
                do inoe = 1, nne
                    do icmp = 1, nbcpf
                        do idim = 1, ndim
                            jj = nbcpf*(inof-1)+icmp
                            ii = ndim*(inoe-1)+idim
                            matref(ii,jj) = matref(ii,jj) -&
                                            wpg*ffl(inof)*ffe(inoe)*jacobi*&
                                            lambda*coefff*a(icmp,idim)
                        end do
                    end do
                end do
            end do
        endif
    else if (phase .eq. 'GLIS') then
        if (.not. l_pena_fric) then
            do inof = 1, nnl
                do inoe = 1, nne
                    do icmp = 1, nbcpf
                        do idim = 1, ndim
                            jj = nbcpf*(inof-1)+icmp
                            ii = ndim*(inoe-1)+idim
                            matref(ii,jj) = matref(ii,jj) - &
                                            wpg*ffl(inof)*ffe(inoe)*jacobi*&
                                            lambda*coefff*b(icmp,idim)
                        end do
                    end do
                end do
            end do
        endif
    endif
!
! - MATR_MF
!
    if (phase .eq. 'ADHE') then
        if (.not. l_pena_fric) then
            do inof = 1, nnl
                do inom = 1, nnm
                    do icmp = 1, nbcpf
                        do idim = 1, ndim
                            jj = nbcpf*(inof-1)+icmp
                            ii = ndim*(inom-1)+idim
                            matrmf(ii,jj) = matrmf(ii,jj)+&
                                            wpg*ffl(inof)*ffm(inom)*jacobi*&
                                            lambda*coefff*a(icmp,idim)
                        end do
                    end do
                end do
            end do
        endif
    else if (phase .eq. 'GLIS') then
        if (.not. l_pena_fric) then
            do inof = 1, nnl
                do inom = 1, nnm
                    do icmp = 1, nbcpf
                        do idim = 1, ndim
                            jj = nbcpf*(inof-1)+icmp
                            ii = ndim*(inom-1)+idim
                            matrmf(ii,jj) = matrmf(ii,jj)+&
                                            wpg*ffl(inof)*ffm(inom)*jacobi*&
                                            lambda*coefff*b(icmp,idim)
                        end do
                    end do
                end do
            end do
        endif
    endif
!
! - MATR_EE
!
    if (phase .eq. 'ADHE') then
        if (l_pena_fric) then
            do i = 1, nne
                do j = 1, nne
                    do l = 1, ndim
                        do k = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matree(ii,jj) = matree(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffe(i)*e(l,k)*ffe(j)
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nne
                do j = 1, nne
                    do l = 1, ndim
                        do k = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matree(ii,jj) = matree(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffe(i)*e(l,k)*ffe(j)
                        end do
                    end do
                end do
            end do
        endif
    elseif (phase .eq.'GLIS') then
        if (l_pena_fric) then
            do i = 1, nne
                do j = 1, nne
                    do l = 1, ndim
                        do k = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matree(ii,jj) = matree(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffe(i)*d(l,k)*ffe(j)
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nne
                do j = 1, nne
                    do l = 1, ndim
                        do k = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matree(ii,jj) = matree(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffe(i)*d(l,k)*ffe(j)
                        end do
                    end do
                end do
            end do
        endif
    endif
!
! - MATR_MM
!
    if (phase .eq. 'ADHE') then
        if (l_pena_fric) then
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+k
                            jj = ndim*(j-1)+l
                            matrmm(ii,jj) = matrmm(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffm(i)*e(k,l)*ffm(j)
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+k
                            jj = ndim*(j-1)+l
                            matrmm(ii,jj) = matrmm(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffm(i)*e(k,l)*ffm(j)
                        end do
                    end do
                end do
            end do
        endif
    elseif (phase .eq. 'GLIS') then
        if (l_pena_fric) then
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matrmm(ii,jj) = matrmm(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffm(i)*d(l,k)*ffm(j)
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nnm
                do j = 1, nnm
                    do k = 1, ndim
                        do l = 1, ndim
                            ii = ndim*(i-1)+l
                            jj = ndim*(j-1)+k
                            matrmm(ii,jj) = matrmm(ii,jj) -&
                                            coefaf*coefff*lambda*wpg*jacobi*ffm(i)*d(l,k)*ffm(j)
                        end do
                    end do
                end do
            end do
        endif
    endif
!
! - MATR_ME
!
    if (phase .eq. 'ADHE') then
        do i = 1, nnm
            do j = 1, nne
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+k
                        jj = ndim*(j-1)+l
                        matrme(ii,jj) = matrme(ii,jj) +&
                                        coefaf*coefff*lambda*wpg*jacobi*ffm(i)*e(l,k)*ffe(j)
                    end do
                end do
            end do
        end do
    elseif (phase .eq. 'GLIS') then
        do i = 1, nnm
            do j = 1, nne
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrme(ii,jj) = matrme(ii,jj) +&
                                        coefaf*coefff*lambda*wpg*jacobi*ffm(i)*d(l,k)*ffe(j)
                    end do
                end do
            end do
        end do
    endif
!
! - MATR_EM
!
    if (phase .eq. 'ADHE') then
        do i = 1, nne
            do j = 1, nnm
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrem(ii,jj) = matrem(ii,jj) +&
                                        coefaf*coefff*lambda*wpg*jacobi*ffe(i)*e(k,l)*ffm(j)
                    end do
                end do
            end do
        end do
    elseif (phase .eq. 'GLIS') then
        do i = 1, nne
            do j = 1, nnm
                do k = 1, ndim
                    do l = 1, ndim
                        ii = ndim*(i-1)+l
                        jj = ndim*(j-1)+k
                        matrem(ii,jj) = matrem(ii,jj) +&
                                        coefaf*coefff*lambda*wpg*jacobi*ffe(i)*d(l,k)*ffm(j)
                    end do
                end do
            end do
        end do
    endif
!
! - MATR_EC
!
    if (i_reso_fric .eq. ALGO_NEWT) then
        if (phase .eq. 'ADHE') then
            if (.not. l_pena_fric) then
                do inoc = 1, nnl
                    do inoe = 1, nne
                        do idim = 1, ndim
                            jj = ndim*(inoe-1)+idim
                            matrec(jj,inoc) = matrec(jj,inoc) -&
                                              coefff*wpg*ffl(inoc)*ffe(inoe)*jacobi*&
                                              (pdlaft(idim)+coefaf*pdjeut(idim))
                        end do
                    end do
                end do
            endif
        else if (phase .eq. 'GLIS') then
            if (.not. l_pena_fric) then
                do inoc = 1, nnl
                    do inoe = 1, nne
                        do idim = 1, ndim
                            jj = ndim*(inoe-1)+idim
                            matrec(jj,inoc) = matrec(jj,inoc) -&
                                              coefff*wpg*ffl(inoc)*ffe(inoe)*jacobi*prese(idim)
                        end do
                    end do
                end do
            endif
        endif
    endif
!
! - MATR_MC
!
    if (i_reso_fric .eq. ALGO_NEWT) then
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
    endif
!
! - MATR_FF
!
    if (phase .eq. 'SANS' .or. phase .eq. 'NCON') then
        do i = 1, nnl
            do j = 1, nnl
                do l = 1, nbcpf
                    do k = 1, nbcpf
                        ii = (ndim-1)*(i-1)+l
                        jj = (ndim-1)*(j-1)+k
                        matrff(ii,jj) = matrff(ii,jj)+&
                                        wpg*ffl(i)*ffl(j)*jacobi*tt(l,k)
                    end do
                end do
            end do
        end do
    else if (phase .eq. 'GLIS') then
        if (l_pena_fric) then
            do i = 1, nnl
                do j = 1, nnl
                    do l = 1, nbcpf
                        do k = 1, nbcpf
                            ii = (ndim-1)*(i-1)+l
                            jj = (ndim-1)*(j-1)+k
                            matrff(ii,jj) = matrff(ii,jj)+&
                                            wpg*ffl(i)*ffl(j)*jacobi*tt(l,k)*coefff*lambda/coefaf
                        end do
                    end do
                end do
            end do
        else
            do i = 1, nnl
                do j = 1, nnl
                    do l = 1, nbcpf
                        do k = 1, nbcpf
                            ii = (ndim-1)*(i-1)+l
                            jj = (ndim-1)*(j-1)+k
                            matrff(ii,jj) = matrff(ii,jj)+&
                                            wpg*ffl(i)*ffl(j)*jacobi*coefff*lambda*r(l,k)/coefaf
                        end do
                    end do
                end do
            end do
        endif
    else if (phase .eq. 'ADHE') then
        if (l_pena_fric) then
            do i = 1, nnl
                do j = 1, nnl
                    do l = 1, nbcpf
                        do k = 1, nbcpf
                            ii = (ndim-1)*(i-1)+l
                            jj = (ndim-1)*(j-1)+k
                            matrff(ii,jj) = matrff(ii,jj)+&
                                            wpg*ffl(i)*ffl(j)*jacobi*tt(l,k)*coefff*lambda/coefaf
                        end do
                    end do
                end do
            end do
        endif
    endif
!
! - MATR_FE
!
    if (phase .eq. 'ADHE') then
        do inof = 1, nnl
            do inoe = 1, nne
                do icmp = 1, nbcpf
                    do idim = 1, ndim
                        ii = nbcpf*(inof-1)+icmp
                        jj = ndim*(inoe-1)+idim
                        matrfe(ii,jj) = matrfe(ii,jj)-&
                                        wpg*ffl(inof)*ffe(inoe)*jacobi* lambda*coefff*a(icmp,idim)
                    end do
                end do
            end do
        end do
    else if (phase .eq. 'GLIS') then
        do inof = 1, nnl
            do inoe = 1, nne
                do icmp = 1, nbcpf
                    do idim = 1, ndim
                        ii = nbcpf*(inof-1)+icmp
                        jj = ndim*(inoe-1)+idim
                        matrfe(ii,jj) = matrfe(ii,jj)-&
                                        wpg*ffl(inof)*ffe(inoe)*jacobi* lambda*coefff*b(icmp,idim)
                    end do
                end do
            end do
        end do
    endif
!
! - MATR_FM
!
    if (phase .eq. 'ADHE') then
        do inof = 1, nnl
            do inom = 1, nnm
                do icmp = 1, nbcpf
                    do idim = 1, ndim
                        ii = nbcpf*(inof-1)+icmp
                        jj = ndim*(inom-1)+idim
                        matrfm(ii,jj) = matrfm(ii,jj)+&
                                        wpg*ffl(inof)*ffm(inom)*jacobi*lambda*coefff*a(icmp,idim)
                    end do
                end do
            end do
        end do
    else if (phase(1:4).eq.'GLIS') then
        do inof = 1, nnl
            do inom = 1, nnm
                do icmp = 1, nbcpf
                    do idim = 1, ndim
                        ii = nbcpf*(inof-1)+icmp
                        jj = ndim*(inom-1)+idim
                        matrfm(ii,jj) = matrfm(ii,jj)+&
                                        wpg*ffl(inof)*ffm(inom)*jacobi*lambda*coefff*b(icmp,idim)
                    end do
                end do
            end do
        end do
    endif
!
! - Non-linear geometric contribution
!
    if (i_reso_geom .eq. ALGO_NEWT) then
        if (phase .eq. 'GLIS' .and. l_large_slip) then
            call mmgtuu(ndim  , nne   , nnm   ,&
                        wpg   , ffe   , ffm   , dffm  , ddffm ,&
                        jacobi, coefac, coefff, jeu   , dlagrc,&
                        mprt1n, mprt2n, mprnt1, mprnt2,&
                        kappa , vech1 , vech2 , h     ,&
                        mprt11, mprt12, mprt21, mprt22,&
                        matrmm, matrem, matrme)
        endif
    endif
!
! - Excluded direction of friction
!
    call mmmtex(ndexfr, ndim  , nnl   , nne   , nnm   , nbcps,&
                matrff, matrfe, matrfm, matref, matrmf)
!
! - Assembling (friction here => nbcps > 0)
!
    call mmmtas(nbdm     , ndim  , nnl   , nne   , nnm   , nbcps,&
                matrcc   , matree, matrmm, matrem,&
                matrme   , matrce, matrcm, matrmc, matrec,&
                matr_fric,&
                matrff   , matrfe, matrfm, matrmf, matref)
!
end subroutine
