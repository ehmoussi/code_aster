subroutine lcgrad_bis(resi, rigi, sig, apg, lag, grad, aldc,&
                  r, c, deps_sig,dphi_sig,deps_a,dphi_a, sief, dsde)
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
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: resi, rigi
    real(kind=8),intent(in) :: sig(:), apg, lag, grad(:), aldc, r, c
    real(kind=8),intent(in) :: deps_sig(:,:),dphi_sig(:),deps_a(:),dphi_a
    real(kind=8)            :: sief(*), dsde(:,:)
! ----------------------------------------------------------------------
!  GRAD_VARI : CALCUL DES TERMES COMMUNS AU LAGRANGIEN AUGMENTE
! ----------------------------------------------------------------------
! IN  RESI     .TRUE. SI CALCUL DES CONTRAINTES
! IN  RIGI     .TRUE. SI CALCUL DE LA RIGIDITE
! IN  SIG      CONTRAINTES MECANIQUES
! IN  APG      VARIABLE NON LOCALE NODALE INTERPOLEE AU POINT DE GAUSS
! IN  LAG      MULTIPLICATEUR DE LAGRANGE
! IN  GRAD     GRADIENT DE LA VARIABLE NON LOCALE
! IN  ALDC     VARIABLE NON LOCALE ISSUE DE LA LOI DE COMPORTEMENT
! IN  R        COEFFICIENT D'AUGMENTATION DU LAGRANGIEN AUGMENTE
! IN  C        COEFFICIENT DE PONDERATION DU TERME NON LOCAL
! IN  DEPS_SIG DSIGMA/DEPS
! IN  DPHI_SIG DSIGMA/DPHI
! IN  DEPS_A   DALDC/DEPS
! IN  DPHI_A   DALDC/DPHI
! OUT SIEF     CONTRAINTES GENERALISEES
! OUT DSDE     MATRICE TANGENTE GENERALISEE
! ----------------------------------------------------------------------
    integer :: i,neps,ndim,ndimsi
! ----------------------------------------------------------------------

! Initialisation
    ndim   = size(grad)
    ndimsi = 2*ndim
    neps   = 3*ndim + 2
    ASSERT(size(sig).eq.ndimsi)
    ASSERT(size(dsde,1).eq.neps)
    ASSERT(size(dsde,2).eq.neps)


! -- CALCUL DES CONTRAINTES GENERALISEES
    if (resi) then
        sief(1:ndimsi) = sig
        sief(ndimsi+1) = lag + r*(apg-aldc)
        sief(ndimsi+2) = apg-aldc
        sief(ndimsi+3:ndimsi+2+ndim) = c*grad
    endif


! -- CALCUL DE LA MATRICE TANGENTE GENERALISEE
    if (rigi) then
        dsde = 0.d0

        ! SIG - EPS
        dsde(1:ndimsi,1:ndimsi) = deps_sig

        ! SIG - A ET SIG - MU
        dsde(1:ndimsi,ndimsi+1) = dphi_sig*r
        dsde(1:ndimsi,ndimsi+2) = dphi_sig

        ! SIGA - EPS ET SIGMU - EPS
        dsde(ndimsi+1,1:ndimsi) = -deps_a*r
        dsde(ndimsi+2,1:ndimsi) = -deps_a

        ! SIGA - A
        dsde(ndimsi+1,ndimsi+1) = (1-r*dphi_a)*r

        ! SIGA - MU ET SIGMU - A
        dsde(ndimsi+1,ndimsi+2) = 1-r*dphi_a
        dsde(ndimsi+2,ndimsi+1) = 1-r*dphi_a

        ! SIGMU - MU
        dsde(ndimsi+2,ndimsi+2) = -dphi_a

        ! SIGG - GRAD
        do i = 1, ndim
            dsde(ndimsi+2+i,ndimsi+2+i) = c
        end do
    endif

end subroutine
