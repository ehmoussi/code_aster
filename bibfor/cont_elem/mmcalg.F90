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
subroutine mmcalg(ndim     , l_large_slip,&
                  nnm      , dffm     , ddffm ,&
                  geomam   , ddepmam  ,&
                  tau1     , tau2     , norm  ,&
                  jeu      , djeu     ,&
                  gene11   , gene21   , gene22,&
                  kappa    , h        ,&
                  vech1    , vech2    ,&
                  a        , ha       , hah   ,&
                  mprt11   , mprt12   , mprt21, mprt22,&
                  mprt1n   , mprt2n   , mprnt1, mprnt2,&
                  taujeu1  , taujeu2  ,&
                  dnepmait1, dnepmait2)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/matinv.h"
!
integer, intent(in) :: ndim, nnm
aster_logical, intent(in) :: l_large_slip
real(kind=8), intent(in) :: dffm(2, 9), ddffm(3,9)
real(kind=8), intent(in) :: geomam(9, 3), ddepmam(9, 3)
real(kind=8), intent(in) :: tau1(3), tau2(3), norm(3)
real(kind=8), intent(in) :: jeu, djeu(3)
real(kind=8), intent(out) :: gene11(3, 3), gene21(3, 3), gene22(3,3)
real(kind=8), intent(out) :: kappa(2,2), h(2,2)
real(kind=8), intent(out) :: vech1(3), vech2(3)
real(kind=8), intent(out) :: a(2,2), ha(2,2), hah(2,2)
real(kind=8), intent(out) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
real(kind=8), intent(out) :: mprt1n(3, 3), mprt2n(3, 3), mprnt1(3, 3), mprnt2(3, 3)
real(kind=8), intent(out) :: taujeu1, taujeu2
real(kind=8), intent(out) :: dnepmait1, dnepmait2
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute geometric quantities for second variation of gap
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  l_large_slip     : flag for GRAND_GLISSEMENT
! In  nnm              : number of master nodes
! In  dffm             : first derivative of shape function for master nodes
! In  ddffm            : second derivative of shape function for master nodes
! In  geomam           : updated geometry for master nodes
! In  ddepmam          : increment of displacement from beginning of time step for master nodes
! In  tau1             : first tangent at current contact point
! In  tau2             : second tangent at current contact point
! In  norm             : normal at current contact point
! In  jeu              : normal gap
! In  djeu             : increment of normal gap
! Out mprt1n           : projection matrix first tangent/normal
! Out mprt2n           : projection matrix second tangent/normal
! Out mprnt1           : projection matrix normal/first tangent
! Out mprnt2           : projection matrix normal/second tangent
! Out mprt11           : projection matrix first tangent/first tangent
!                        tau1*TRANSPOSE(tau1)(matrice 3*3)
! Out mprt12           : projection matrix first tangent/second tangent
!                        tau1*TRANSPOSE(tau2)(matrice 3*3)
! Out mprt21           : Projection matrix second tangent/first tangent
!                        tau2*TRANSPOSE(tau1)(matrice 3*3)
! Out mprt22           : Projection matrix second tangent/second tangent
!                        tau2*TRANSPOSE(tau2)(matrice 3*3)
! Out gene11           : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
!                        DDGEOMM(1,1)/NORMALE  (matrice 3*3)
! Out gene21           : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
!                        DDGEOMM(2,1)/NORMALE  (matrice 3*3)
! Out gene22           : MATRICE EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
!                        DDGEOMM(2,2)/NORMALE  (matrice 3*3)
! Out KAPPA            : MATRICE DE SCALAIRES LIEES A LA CINEMATIQUE DU GLISSEMENT
!                        KAPPA(i,j) = INVERSE[tau_i.tau_j-JEU*(ddFFM*geomm)](matrice 2*2)
! Out H                : MATRICE DE SCALAIRES EULERIENNE DUE A LA REGULARITE DE LA SURFACE MAITRE
!                        H(i,j) = JEU*{[DDGEOMM(i,j)].n} (matrice 2*2)
! Out A                : MATRICE DE SCALAIRES DUE AU TENSEUR DE WEINTGARTEN
!                        A(i,j) = [tau_i.tau_j] (matrice 2*2)
! Out HA               : H/A   (matrice 2*2)
! Out HAH              : HA/H  (matrice 2*2)
! Out VECH_1           : KAPPA(1,m)*tau_m
! Out VECH_2           : KAPPA(2,m)*tau_m
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, inom, idim
    real(kind=8) :: ddgeo1(3), ddgeo2(3), ddgeo3(3), detkap, ddepmait1(3), ddepmait2(3)
    real(kind=8) :: long_mmait(24), valmoy=0.0, kappa_in(2,2)
!
! --------------------------------------------------------------------------------------------------
!
    dnepmait1     = 0.d0
    dnepmait2     = 0.d0
    taujeu1       = 0.d0
    taujeu2       = 0.d0
    mprt1n(:,:)   = 0.d0
    mprt2n(:,:)   = 0.d0
    mprnt1(:,:)   = 0.d0
    mprnt2(:,:)   = 0.d0
    mprt11(:,:)   = 0.d0
    mprt12(:,:)   = 0.d0
    mprt21(:,:)   = 0.d0
    mprt22(:,:)   = 0.d0
    a(:,:)        = 0.d0
    h(:,:)        = 0.d0
    ha(:,:)       = 0.d0
    hah(:,:)      = 0.d0
    gene11(:,:)   = 0.d0
    gene21(:,:)   = 0.d0
    gene22(:,:)   = 0.d0
    kappa (:,:)   = 0.d0
    kappa_in(:,:) = 0.d0
    vech1(:)      = 0.d0
    vech2(:)      = 0.d0
    ddgeo1(:)     = 0.d0
    ddgeo2(:)     = 0.d0
    ddgeo3(:)     = 0.d0
    ddepmait1(:)  = 0.d0
    ddepmait2(:)  = 0.d0
    long_mmait(:) = 0.d0

    if (l_large_slip) then
        do idim = 1, ndim
            do inom = 1, nnm
                ddepmait1(idim) = ddepmait1(idim) + dffm(1,inom)*ddepmam(inom,idim)
                ddepmait2(idim) = ddepmait2(idim) + dffm(2,inom)*ddepmam(inom,idim)
            end do
        end do
!
    ! Sur la géométrie courante de l'élément esclave on calcule la
    ! distance du Noeud I=2,9 par rapport à au noeud 1
    ! Puis on calcule la moyenne
    !       write (6,*) "GEOMAM",geomam(1,1)
        long_mmait(1) = sqrt(abs(geomam(1,1) - geomam(2,1)))**2
        long_mmait(2) = sqrt(abs(geomam(1,2) - geomam(2,2)))**2
        long_mmait(3) = sqrt(abs(geomam(1,3) - geomam(2,3)))**2
        long_mmait(4) = sqrt(abs(geomam(1,1) - geomam(3,1)))**2
        long_mmait(5) = sqrt(abs(geomam(1,2) - geomam(3,2)))**2
        long_mmait(6) = sqrt(abs(geomam(1,3) - geomam(3,3)))**2
        long_mmait(7) = sqrt(abs(geomam(1,3) - geomam(4,1)))**2
        long_mmait(8) = sqrt(abs(geomam(1,3) - geomam(4,2)))**2
        long_mmait(9) = sqrt(abs(geomam(1,3) - geomam(4,3)))**2
        long_mmait(10) = sqrt(abs(geomam(1,3) - geomam(5,1)))**2
        long_mmait(11) = sqrt(abs(geomam(1,3) - geomam(5,2)))**2
        long_mmait(12) = sqrt(abs(geomam(1,3) - geomam(5,3)))**2
        long_mmait(13) = sqrt(abs(geomam(1,3) - geomam(6,1)))**2
        long_mmait(14) = sqrt(abs(geomam(1,3) - geomam(6,2)))**2
        long_mmait(15) = sqrt(abs(geomam(1,3) - geomam(6,3)))**2
        long_mmait(16) = sqrt(abs(geomam(1,3) - geomam(7,1)))**2
        long_mmait(17) = sqrt(abs(geomam(1,3) - geomam(7,2)))**2
        long_mmait(18) = sqrt(abs(geomam(1,3) - geomam(7,3)))**2
        long_mmait(19) = sqrt(abs(geomam(1,3) - geomam(8,1)))**2
        long_mmait(20) = sqrt(abs(geomam(1,3) - geomam(8,2)))**2
        long_mmait(21) = sqrt(abs(geomam(1,3) - geomam(8,3)))**2
        long_mmait(22) = sqrt(abs(geomam(1,3) - geomam(9,1)))**2
        long_mmait(23) = sqrt(abs(geomam(1,3) - geomam(9,2)))**2
        long_mmait(24) = sqrt(abs(geomam(1,3) - geomam(9,3)))**2
        valmoy =  0.
        do i = 1,24
            valmoy = valmoy + long_mmait(i)/24
        end do

        do  idim = 1, ndim
           if ((abs(jeu) .lt. 1.d-6) .and. (norm2(ddepmait1) .lt. 1.d-2*valmoy) .and.&
               (norm2(ddepmait2) .lt. 1.d-2*valmoy)) then
          ! On rajoute ce terme au grand glissement seulement si on est sur
          ! d'avoir converge en DEPDEL
          ! increment de deplacement
          ! Test : ssnp154d, ssnv128r, ssnv128p --> Débrancher la condition if et tester ces 2 cas.
          ! Ici on implante une strategie qui consiste a dire que ce terme n'est rajoute que
          ! si le depdel est < 1.d-1*la logueur de la maille maître courante
                dnepmait1 = dnepmait1 + ddepmait1(idim)*norm(idim)*jeu
                dnepmait2 = dnepmait2 + ddepmait2(idim)*norm(idim)*jeu
            endif
            taujeu1 = taujeu1 + tau1(idim)*djeu(idim) + dnepmait1
            taujeu2 = taujeu2 + tau2(idim)*djeu(idim) + dnepmait2
        end do
    endif
!
! - CALCUL DE DDGEOMM
!
    do  idim = 1, ndim
        do  inom = 1, nnm
            ddgeo1(idim) = ddgeo1(idim) + ddffm(1,inom)*geomam(inom,idim)
            ddgeo2(idim) = ddgeo2(idim) + ddffm(2,inom)*geomam(inom,idim)
            ddgeo3(idim) = ddgeo3(idim) + ddffm(3,inom)*geomam(inom,idim)
        enddo
    end do
!
! - Projection matrix first tangent/normal
!
    do  i = 1, ndim
        do  j = 1, ndim
            mprt1n(i,j) = 1.d0*tau1(i)*norm(j)
        enddo
    end do
!
! - Projection matrix second tangent/normal
!
    do  i = 1, ndim
        do  j = 1, ndim
            mprt2n(i,j) = 1.d0*tau2(i)*norm(j)
        enddo
    end do
!
! - Projection matrix normal/first tangent
!
    mprnt1(1,1) = mprt1n(1,1)
    mprnt1(2,2) = mprt1n(2,2)
    mprnt1(3,3) = mprt1n(3,3)
    mprnt1(1,2) = mprt1n(2,1)
    mprnt1(1,3) = mprt1n(3,1)
    mprnt1(2,1) = mprt1n(1,2)
    mprnt1(2,3) = mprt1n(3,2)
    mprnt1(3,1) = mprt1n(1,3)
    mprnt1(3,2) = mprt1n(2,3)
!
! - Projection matrix normal/second tangent
!
      mprnt2(1,1) = mprt2n(1,1)
      mprnt2(2,2) = mprt2n(2,2)
      mprnt2(3,3) = mprt2n(3,3)
      mprnt2(1,2) = mprt2n(2,1)
      mprnt2(1,3) = mprt2n(3,1)
      mprnt2(2,1) = mprt2n(1,2)
      mprnt2(2,3) = mprt2n(3,2)
      mprnt2(3,1) = mprt2n(1,3)
      mprnt2(3,2) = mprt2n(2,3)
!
! - Projection matrix first tangent/first tangent
!
    do  i = 1, ndim
        do  j = 1, ndim
            mprt11(i,j) = 1.d0*tau1(i)*tau1(j)
        enddo
    end do
!
! - Projection matrix second tangent/first tangent
!
    do i = 1, ndim
        do  j = 1, ndim
            mprt21(i,j) = 1.d0*tau2(i)*tau1(j)
        enddo
    end do
!
! - Projection matrix first tangent/second tangent
!
    do i = 1, ndim
        do  j = 1, ndim
            mprt12(i,j) = 1.d0*tau1(i)*tau2(j)
        enddo
    end do
!
! - Projection matrix second tangent/second tangent
!
    do  i = 1, ndim
        do  j = 1, ndim
            mprt22(i,j) = 1.d0*tau2(i)*tau2(j)
        enddo
    end do
!
! - MATRICE GENE11,GENE21,GENE22
!
    do  i = 1, ndim
        do  j = 1, ndim
            do  inom = 1, nnm
                gene11(i,j) = gene11(i,j)+ ddffm(1,inom)*geomam(inom, i)*norm(j)
                gene22(i,j) = gene11(i,j)+ ddffm(2,inom)*geomam(inom, i)*norm(j)
                gene21(i,j) = gene21(i,j)+ ddffm(3,inom)*geomam(inom, i)*norm(j)
            enddo
        enddo
    end do
!
! - MATRICES A
!
    a(1,1) = tau1(1)*tau1(1)+tau1(2)*tau1(2)+tau1(3)*tau1(3)
    a(1,2) = tau1(1)*tau2(1)+tau1(2)*tau2(2)+tau1(3)*tau2(3)
    a(2,1) = a(1,2)
    a(2,2) = tau2(1)*tau2(1)+tau2(2)*tau2(2)+tau2(3)*tau2(3)
!
! - MATRICES H
!
    h(1,1) = jeu*(ddgeo1(1)*norm(1)+ddgeo1(2)*norm(2)+ddgeo1(3)*norm(3))
    h(1,2) = jeu*(ddgeo3(1)*norm(1)+ddgeo3(2)*norm(2)+ddgeo3(3)*norm(3))
    h(2,1) =      h(1,2)
    h(2,2) = jeu*(ddgeo2(1)*norm(1)+ddgeo2(2)*norm(2)+ddgeo2(3)*norm(3))
!
! - MATRICES HA
!
    ha(1,1) = h(1,1)*a(1,1)+h(1,2)*a(2,1)
    ha(1,2) = h(1,1)*a(1,2)+h(1,2)*a(2,2)
    ha(2,1) = h(2,1)*a(1,1)+h(2,2)*a(2,1)
    ha(2,2) = h(2,1)*a(1,2)+h(2,2)*a(2,2)
!
! - MATRICES HAH
!
    hah(1,1) = ha(1,1)*h(1,1)+ha(1,2)*h(2,1)
    hah(1,2) = ha(1,1)*h(1,2)+ha(1,2)*h(2,2)
    hah(2,1) = ha(2,1)*h(1,1)+ha(2,2)*h(2,1)
    hah(2,2) = ha(2,1)*h(1,2)+ha(2,2)*h(2,2)
!
! - MATRICES KAPPA
!
    kappa_in = a - h
    call matinv('C', 2, kappa_in, kappa, detkap)
!
! - VECTEUR VECH1
!
    vech1(1) = kappa(1,1)*tau1(1)+kappa(1,2)*tau2(1)
    vech1(2) = kappa(1,1)*tau1(2)+kappa(1,2)*tau2(2)
    vech1(3) = kappa(1,1)*tau1(3)+kappa(1,2)*tau2(3)
!
! - VECTEUR VECH2
!
    vech2(1) = kappa(2,1)*tau1(1)+kappa(1,2)*tau2(1)
    vech2(2) = kappa(2,1)*tau1(2)+kappa(1,2)*tau2(2)
    vech2(3) = kappa(2,1)*tau1(3)+kappa(1,2)*tau2(3)
!
end subroutine
