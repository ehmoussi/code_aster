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



! --------------------------------------------------------------------
!  SD pour la manipulation des deformations logarithmiques
! --------------------------------------------------------------------

module gdlog_module

implicit none

#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/deflg2.h"
#include "asterfort/deflg3.h"
#include "asterfort/deflog.h"
#include "asterfort/lcdetf.h"
#include "asterfort/nmfdff.h"
#include "asterfort/pk2sig.h"
#include "asterfort/symt46.h"
#include "blas/dgemm.h"
#include "blas/dgemv.h"
#include "blas/dger.h"

type GDLOG_DS
    private
    integer      :: ndim
    integer      :: nno
    aster_logical:: init_ds
    aster_logical:: calc_defo
    aster_logical:: calc_matb
    aster_logical:: axi
    aster_logical:: rigi
    real(kind=8) :: f(3,3)
    real(kind=8) :: gn(3,3)
    real(kind=8) :: lamb(3)
    real(kind=8) :: logl(3)
    real(kind=8) :: pes(6,6)
    real(kind=8) :: feta(4) 
    real(kind=8) :: xi(3, 3)
    real(kind=8) :: me(3, 3, 3, 3)
    real(kind=8),dimension(:,:,:),pointer:: deft
    real(kind=8),dimension(:,:,:),pointer:: pff
    real(kind=8),dimension(:),pointer    :: axf
end type GDLOG_DS


public:: gdlog_init
public:: gdlog_defo
public:: gdlog_matb
public:: gdlog_rigeo
public:: gdlog_nice_cauchy
public:: gdlog_delete


contains

subroutine gdlog_init(self,ndim,nno,axi,rigi)

! ----------------------------------------------------------------------
!   Creation de l'objet GDLOG_DS
! ----------------------------------------------------------------------
! in ndim dimension de l'espace
! in nno  nbr de noeuds pour les deplacements
! in axi  axi ou pas
! in rigi calculera-t-on des matrices de rigidite geometrique ou pas
! ----------------------------------------------------------------------

    implicit none
    type(GDLOG_DS)    :: self
    integer           :: ndim,nno
    aster_logical     :: axi,rigi
! ---------------------------------------------------------------------

    self%ndim      = ndim
    self%nno       = nno
    self%init_ds   = .true.
    self%calc_defo = .false.
    self%calc_matb = .false.
    self%axi       = axi
    self%rigi      = rigi

    allocate(self%deft(2*ndim,ndim,nno))
    allocate(self%pff(2*ndim,nno,nno))
    allocate(self%axf(nno))

end subroutine gdlog_init

! =====================================================================



subroutine gdlog_defo(self, f, eps, iret)

! ----------------------------------------------------------------------
!     CALCUL DES DEFORMATIONS LOGARITHMIQUES 
! ----------------------------------------------------------------------
!     in    f     gradient de la transformation sur la config initiale
!     out   eps   def. log.
!     out   iret  0=ok, 1=vp(ft.f) trop petites (compression infinie)
! ----------------------------------------------------------------------

    implicit none
    type(GDLOG_DS)          :: self
    real(kind=8),intent(in) :: f(3,3)
    real(kind=8),intent(out):: eps(:)
    integer,intent(out)     :: iret
! ----------------------------------------------------------------------
    real(kind=8):: eps6(6)
! ----------------------------------------------------------------------

    ! initialisation
    self%calc_matb = .false.


    ! Controle de coherence
    ASSERT(self%init_ds)
    ASSERT(size(eps).eq.2*self%ndim)


    ! Calcul des elements cinematiques et des deformations
    call deflog(self%ndim, f, eps6, self%gn, self%lamb,self%logl, iret)
    self%calc_defo = (iret.eq.0)
    if (iret.ne.0) goto 999
    eps = eps6(1:2*self%ndim)
    self%f = f

999 continue
end subroutine gdlog_defo

! =====================================================================



subroutine gdlog_matb(self,r,vff,dff,matb)

! ----------------------------------------------------------------------
!     Calcul matrice B tq dElog = B . dU
! ----------------------------------------------------------------------
! in  r    rayon courant (en axi)
! in  vff  valeur des fonctions de forme 
! in  dff  derivee des fonctions de forme
! out matb matrice b
! ----------------------------------------------------------------------

    implicit none
    type(GDLOG_DS)                  :: self
    real(kind=8),intent(in)         :: r
    real(kind=8),intent(in)         :: vff(:)
    real(kind=8),intent(in)         :: dff(:,:)
    real(kind=8),intent(out)        :: matb(:,:,:)
! ---------------------------------------------------------------------
    integer                 :: ndimsi,nno,ndim,kl
    real(kind=8),allocatable:: def(:,:,:)
! ---------------------------------------------------------------------

    ASSERT(self%calc_defo)

    ! Initialisation
    ndim   = self%ndim
    nno    = self%nno
    ndimsi = 2*ndim
    allocate(def(ndimsi,nno,ndim))


    ! Calcul de la matrice PES de passage T -> PK2
    call deflg2(self%gn, self%lamb, self%logl, self%pes, self%feta, self%xi, self%me)


    ! Derivee premiere et seconde du tenseur de Green-Lagrange (lien log <-> GL)
    call nmfdff(ndim, nno, self%axi, 1, r,self%rigi, ASTER_FALSE, self%f, vff, dff, def, self%pff)
    do kl = 1,ndimsi
        self%deft(kl,:,:) = transpose(def(kl,:,:))
    end do
    if (self%axi) then
        self%axf = vff/r
    else
        self%axf = 0
    end if


    ! matb = pes:def
    call dgemm('n','n',ndimsi,ndim*nno,ndimsi,1.d0,self%pes,6,self%deft,ndimsi,0.d0,matb,ndimsi)


    self%calc_matb = .true.
    deallocate(def)
end subroutine gdlog_matb

! =====================================================================



function gdlog_rigeo(self,t) result(matr)

! ----------------------------------------------------------------------
!     Calcul de la rigidite geometrique T:d2E
! ----------------------------------------------------------------------
! in  t     tenseur de contrainte T
! out matr  matrice tangente de rigidite geometrique (ndim,nno,ndim,nno)
! ----------------------------------------------------------------------

    implicit none
    type(GDLOG_DS)         :: self
    real(kind=8),intent(in):: t(:)
    real(kind=8)           :: matr(self%ndim,self%nno,self%ndim,self%nno)
! ---------------------------------------------------------------------
    integer     :: ndimsi,nno,ndim,i
    real(kind=8):: t6(6),tls3(3, 3, 3, 3),tls(6, 6),pk2(6)
    real(kind=8),allocatable:: maax(:,:)
    real(kind=8),allocatable:: marg(:,:)
    real(kind=8),allocatable:: trv(:,:,:)
! ---------------------------------------------------------------------
    
    ASSERT(self%calc_matb)

    ! identification des dimensions
    ndim   = self%ndim
    ndimsi = 2*ndim
    nno    = self%nno
    allocate(maax(nno,nno))
    allocate(marg(nno,nno))
    allocate(trv(ndimsi,ndim,nno))

    ! Controles de coherence
    ASSERT(size(t).eq.ndimsi)

    ! initialisation
    t6 = 0
    t6(1:ndimsi) = t


! Termes relatifs GDEF_LOG -> GREEN_LAGRANGE

    ! Tenseur L (TLS): terme en de:tls:de hors variation de dT/dE
    call deflg3(self%gn, self%feta, self%xi, self%me, t6, tls3)
    call symt46(tls3, tls)

    ! Calcul de S (PK2) pour le terme en PK2:d2e
    pk2 = matmul(t6,self%pes)


! Rigidite geometrique a partie de de:L:de et S:d2e

    ! Terme axi : S(3) * Nn/r * Nm/r (termes i=j=1)
    maax = 0
    call dger(nno,nno,pk2(3),self%axf,1,self%axf,1,maax,nno)
            
    ! Terme S(kl).PFF(kl,n,m) (termes i=j)
    call dgemv('t',ndimsi,nno*nno,1.d0,self%pff,ndimsi,pk2,1,0.d0,marg,1)

    ! Terme DEFT(ab,i,n):L(ab,kl): DEFT(kl,j,m) = M(j,m,i,n)
    call dgemm('n','n',ndimsi,ndim*nno,ndimsi,1.d0,tls,6,self%deft,ndimsi,0.d0,trv,ndimsi)
    call dgemm('t','n',ndim*nno,ndim*nno,ndimsi,1.d0,trv,ndimsi,self%deft,ndimsi,0.d0,matr,ndim*nno)

    ! Ajout des termes marg (symetrique) et maax (symetrique) -> pas besoin de transposer n <-> m
    forall (i = 1:ndim)
        matr(i,:,i,:) = matr(i,:,i,:) + marg(:,:)
    end forall
    matr(1,:,1,:) = matr(1,:,1,:) + maax(:,:)

    deallocate(maax)
    deallocate(marg)
    deallocate(trv)
end function gdlog_rigeo

! =====================================================================



function gdlog_nice_cauchy(self,t) result(cauchy)

! ----------------------------------------------------------------------
!     Calcule le tenseur de Cauchy (sans racines de deux) a partir de T
! ----------------------------------------------------------------------

    implicit none
    type(GDLOG_DS):: self
    real(kind=8),intent(in):: t(:)
    real(kind=8)           :: cauchy(size(t))
! ----------------------------------------------------------------------
    integer:: ndimsi
    real(kind=8):: t6(6),pk2(6),jac,sig6(6)
! ---------------------------------------------------------------------

    ! tests de coherence
    ndimsi = 2*self%ndim
    ASSERT(self%calc_matb)
    ASSERT(size(t).eq.ndimsi)

    ! PK2
    t6 = 0
    t6(1:ndimsi) = t
    pk2 = matmul(t6,self%pes)

    ! Conversion vers Cauchy
    call lcdetf(self%ndim, self%f, jac)
    call pk2sig(self%ndim, self%f, jac, pk2, sig6, 1)
    cauchy = sig6(1:ndimsi)

end function gdlog_nice_cauchy

! =====================================================================



subroutine gdlog_delete(self)

! ----------------------------------------------------------------------
!     Liberation de l'objet gdlog
! ----------------------------------------------------------------------

    implicit none
    type(GDLOG_DS):: self
! ---------------------------------------------------------------------

    deallocate(self%deft)
    deallocate(self%pff)
    deallocate(self%axf)

end subroutine gdlog_delete

end module gdlog_module