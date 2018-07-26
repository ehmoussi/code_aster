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

subroutine hujini(mod, nmat, mater, intg, deps,&
                  nr, yd, nvi, vind, sigd,&
                  sigf, bnews, mtrac, dy, indi,&
                  iret)
! person_in_charge: alexandre.foucault at edf.fr
    implicit none
!     ----------------------------------------------------------------
!     CALCUL DE LA SOLUTION INITIALE ESSAI DY = ( DSIG DVIN )
!     ----------------------------------------------------------------
!     IN   MOD    :  TYPE DE MODELISATION
!          NMAT   :  DIMENSION TABLEAU MATERIAU
!          MATER  :  PROPRIETES MATERIAU
!          INTG   :  NOMBRE DE TENTATIVES D'INTEGRATION
!          DEPS   :  INCREMENT DEFORMATION TOTALE
!          NR     :  DIMENSION SYSTEME NL A RESOUDRE
!          YD     :  VECTEUR INITIAL A T
!          NVI    :  NOMBRE DE VARIABLES INTERNES
!          VIND   :  VARIABLES INTERNES A T
!          SIGD   :  ETAT DE CONTRAINTES A T
!          SIGF   :  PREDICTION ELASTIQUE
!          BNEWS  :  GESTION TRACTION AVEC HUJEUX
!          MTRAC  :  GESTION TRACTION AVEC HUJEUX (BIS)
!          IRET   :  IRET = 2 - RELANCE DU PROCESSUS DE RESOLUTION
!     OUT  DY     :  INCREMENT INITIAL SUR VECTEUR SOLUTION
!          INDI   :  MECANISMES POTENTIELLEMENT ACTIFS
!          NR     :  NR MIS A JOUR SI TRACTION PRESENTE
!          IRET   :  IRET = 0 (OK) - 3 (NON CVG)
!     ----------------------------------------------------------------
#include "asterf_types.h"
#include "asterfort/hujiid.h"
    character(len=8) :: mod
    integer :: nr, nvi, iret, indi(7), intg, nmat
    real(kind=8) :: mater(nmat, 2), deps(6), yd(18), vind(nvi), sigf(6)
    real(kind=8) :: dy(18), sigd(6)
    aster_logical :: bnews(3), mtrac
!
    real(kind=8) :: i1f, dsig(6), zero, un, trois, pref, e0, matert(22, 2)
    aster_logical :: loop, nodef
    integer :: nbmeca, nbmect, i, ii, ndt, ndi, indis(7), diff
!
    parameter     (ndi   = 3   )
    parameter     (ndt   = 6   )
    parameter     (zero  = 0.d0)
    parameter     (un    = 1.d0)
    parameter     (trois = 3.d0)
!     ----------------------------------------------------------------
!--------------------------
! ---- PROPRIETES MATERIAU
! -------------------------
    pref = mater(8,2)
    e0 = mater(1,1)
!
! --- GESTION DES BOUCLES
    if (iret .eq. 2) then
        loop = .true.
        do i = 1, 7
            indis(i) = indi(i)
        enddo
    else
        loop = .false.
        do i = 1, 7
            indis(i) = 0
        enddo
    endif
!
    iret = 0
!
! --- PREPARATION DE L'APPEL A HUJIID (ROUTINE DE L'ALGO SPECIFIQUE)
  1 continue
!
    if (iret .eq. 3) goto 999
!
! ---  INITIALISATION VECTEUR D'INDICE INDI(I=1,7)
    do i = 1, 7
        indi(i) = 0
    end do
!
! ---  DEFINITION DU NOMBRE DE MECANISMES POTENTIELS ACTIFS
    nbmeca = 0
    do i = 1, 8
        if (vind(23+i) .eq. un) nbmeca = nbmeca + 1
    end do
!
! --- REMPLISSAGE DES MECANISMES POTENTIELLEMENT ACTIFS
!
    ii = 1
    do i = 1, 8
        if (vind(23+i) .eq. un) then
!
            if (i .ne. 4) then
                indi(ii) = i
                yd(ndt+1+ii) = vind(i)
                yd(ndt+1+nbmeca+ii) = zero
                ii = ii + 1
            else
                indi(nbmeca) = i
                yd(ndt+1+nbmeca) = vind(i)
                yd(ndt+1+2*nbmeca) = zero
            endif
!
        endif
    end do
!
! --- REDIMENSIONNEMENT DE YD POUR S'ADAPTER A HUJIID
! --- COPIE A PARTIR DU TRAITEMENT DE HUJMID
    do i = 1, 6
        yd(i) = yd(i)*e0
    end do
!
!
! --- PREPARATION DE L'INCREMENT DE CONTRAINTES
!
    diff = 0
    do i = 1, 7
        diff = diff + indi(i)-indis(i)
    end do
    if ((diff.eq.0) .and. (nbmeca.eq.1)) loop=.false.
!
    if (loop) then
        do i = 1, ndt
            dsig(i) = sigf(i) - sigd(i)
        enddo
    else
        do i = 1, ndt
            dsig(i) = zero
        enddo
    endif
!
    i1f = (sigf(1)+sigf(2)+sigf(3))/trois
!
!
! --- APPEL A HUJIID
!
    do i = 1, 22
        matert(i,1) = mater(i,1)
        matert(i,2) = mater(i,2)
    end do
!
    call hujiid(mod, matert, indi, deps, i1f,&
                yd, vind, dy, loop, dsig,&
                bnews, mtrac, iret)
!
!
! --- CONTROLE SUR LA SOLUTION INITIALE PROPOSEE
!
    nbmect = nbmeca
    do i = 1, 7
        if (indi(i) .gt. 8) then
            nbmect = nbmect + 1
        endif
    end do
!
    nodef = .false.
    if (nbmeca .ne. nbmect) then
        do i = 1, ndi
            if (abs(yd(i)+dsig(i)) .gt. pref**2.d0) nodef = .true.
        enddo
        if (nodef) then
            iret = 3
            if (intg .gt. 5) then
                goto 999
            else
                do i = nbmeca+1, nbmect
                    if (dy(ndt+1+nbmeca+i) .eq. zero) then
                        bnews(indi(i)-8) = .true.
                        iret = 2
                    endif
                enddo
                goto 1
            endif
        endif
    endif
!
! --- REDIMENSIONNEMENT DE YD POUR S'ADAPTER A LCPLNL
! --- COPIE A PARTIR DU TRAITEMENT DE HUJMID
    do i = 1, 6
        yd(i) = yd(i)/e0
        dy(i) = dy(i)/e0
    end do
!
    do i = 1, nbmeca
        yd(ndt+1+i) = yd(ndt+1+i)/e0*abs(pref)
        dy(ndt+1+i) = dy(ndt+1+i)/e0*abs(pref)
    end do
!
    nr = ndt+1+nbmeca+nbmect
!
    do i = nr+1, 18
        dy(i) = zero
    end do
!
999 continue
!
end subroutine
