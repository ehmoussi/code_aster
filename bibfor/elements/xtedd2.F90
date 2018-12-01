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
!
subroutine xtedd2(ndim, jnne, ndeple, jnnm, nddl,&
                  option, lesclx, lmaitx, lcontx, stano,&
                  lact, jddle, jddlm, nfhe, nfhm,&
                  lmulti, heavno, mmat, vtmp)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/indent.h"
#include "asterfort/is_enr_line.h"
!
integer, intent(in) :: ndim, jnnm(3), nddl, stano(*), lact(8)
character(len=16), intent(in) :: option
aster_logical, intent(in) :: lesclx, lmaitx, lcontx, lmulti
integer, intent(in) :: jnne(3), ndeple, jddle(2)
integer, intent(in) :: jddlm(2), nfhe, nfhm, heavno(8)
real(kind=8), optional, intent(out) :: mmat(336, 336)
real(kind=8), optional, intent(out) :: vtmp(336)
!
! --------------------------------------------------------------------------------------------------
!
!     BUT: SUPPRIMER LES DDLS "EN TROP" (VOIR BOOK III 09/06/04
!     ET  BOOK IV  30/07/07) POUR LE CONTACT XFEM GRAND GLISSEMENT
!
!     TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
!
! --------------------------------------------------------------------------------------------------
!
! IN   NDIM   : DIMENSION DE L'ESPACE
! IN   NNES   : NOMBRE DE NOEUDS SOMMETS DE LA MAILLE ESCLAVE
! IN   NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN   NDDL   : NOMBRE DE DDL TOTAL DE L'ÉLÉMENT
! IN   NDLS   : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
! IN   OPTION : OPTION DE CALCUL DU TE
! IN   STANO  : LITE DU STATUT DES NOEUDS
! IN   LACT   : LITE DES LAGRANGES ACTIFS
! IN   LESCLX : LA MAILLE ESCLAVE EST HEAVISIDE CRACK-TIP
! IN   LMAITX : LA MAILLE MAITRE EST HEAVISIDE CRACK-TIP
! IN   LCONTX : CERTAINS DDL DE CONTACT NE SONT PAS ACTIFS
! IN/OUT  MAT : MATRICE DE RIGIDITÉ
! IN/OUT VECT : VECTEUR SECOND MEMBRE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, nddle, in, nnes, nnem, ddles, ddlem, nnm
    integer, parameter :: ddlmax = 336
    integer :: ddlms, ddlmm, ifh, posddl(ddlmax)
    real(kind=8) :: dmax
    aster_logical :: lmat, lvec, lctlin
!
! --------------------------------------------------------------------------------------------------
!
    lmat   = .false.
    lvec   = .false.
    lctlin = is_enr_line()
!
!   OPTIONS RELATIVES A UNE MATRICE
    if (option .eq. 'RIGI_CONT' ) then
        lmat = .true.
!   OPTIONS RELATIVES A UN VECTEUR
    elseif (option .eq. 'CHAR_MECA_CONT') then
        lvec = .true.
    else
        ASSERT(.false.)
    endif
!
!-------------------------------------------------------------
!   VERIFICATION DE LA COHERENCE OPTION / ARGUMENTS OPTIONNELS
!-------------------------------------------------------------
!
    if (present(mmat) .and. .not.present(vtmp)) then
        ASSERT(lmat .and. .not.lvec)
    else if (.not.present(mmat) .and. present(vtmp)) then
        ASSERT(.not.lmat .and. lvec)
!   EXACTEMENT UN DES 2 ARGUMENTS mmat OU vtmp EST OBLIGATOIRE
    else
        ASSERT(.false.)
    endif
!
    nnes=jnne(2)
    nnem=jnne(3)
    nnm=jnnm(1)
    ddles=jddle(1)
    ddlem=jddle(2)
    ddlms=jddlm(1)
    ddlmm=jddlm(2)
    nddle = ddles*nnes+ddlem*nnem
!
! --- REMPLISSAGE DU VECTEUR POS : POSITION DES DDLS A SUPPRIMER
!
    ASSERT(nddl.le.ddlmax)
    posddl(:) = 0
!
    if (lesclx) then
        do i = 1, ndeple
            call indent(i, ddles, ddlem, nnes, in)
!
            if (stano(i) .eq. 1) then
! --- NOEUD HEAVISIDE, ON ELIMINE LES DDL CRACK-TIP
                do j = 1, ndim
                    posddl(in+2*ndim+j)=1
                end do
            else if (abs(stano(i)).eq.2) then
! --- NOEUD CRACK-TIP, ON ELIMINE LES DDL HEAVISIDE
                do j = 1, ndim
                    posddl(in+ndim+j)=1
                end do
!           ON SUPPRIME LES DDLS VECTORIELS DES NOEUDS MILIEUX
                if (i.gt.nnes.and.lctlin) then
                    do j = 1, ndim
                        posddl(in+2*ndim+j)=1
                    enddo
                endif
            else if (stano(i).eq.3) then
!           ON SUPPRIME LES DDLS VECTORIELS DES NOEUDS MILIEUX
                if (i.gt.nnes.and.lctlin) then
                    do j = 1, ndim
                        posddl(in+2*ndim+j)=1
                    enddo
                endif
            endif
        end do
    else
        do i = 1, ndeple
            call indent(i, ddles, ddlem, nnes, in)
            do ifh = 1, nfhe
                if (stano(nfhe*(i-1)+ifh) .eq. 0) then
! --- DANS LE CAS DE MAILLE HEAVISIDE, ON ELIMINE LE DDL HEAVISIDE
                    do j = 1, ndim
                        posddl(in+ndim*ifh+j)=1
                    end do
                endif
            end do
        end do
    endif
    if (lmaitx) then
        do i = 1, nnm
            call indent(i, ddlms, ddlmm, nnm, in)
            in = in + nddle
            if (stano(ndeple+i) .eq. 1) then
! --- NOEUD HEAVISIDE, ON ELIMINE LES DDL CRACK-TIP
                do j = 1, ndim
                    posddl(in+2*ndim+j)=1
                end do
            else if (abs(stano(ndeple+i)).eq.2) then
! --- LE NOEUD EST CRACK-TIP, ON ELIMINE HEAVISIDE
                do j = 1, ndim
                    posddl(in+ndim+j)=1
                end do
            endif
        end do
    else
        do i = 1, nnm
            call indent(i, ddlms, ddlmm, nnm, in)
            in = in + nddle
            do ifh = 1, nfhm
                if (stano(nfhe*ndeple+nfhm*(i-1)+ifh) .eq. 0) then
! --- DANS LE CAS DE MAILLE HEAVISIDE, ON ELIMINE LE DDL HEAVISIDE
                    do j = 1, ndim
                        posddl(in+ndim*ifh+j)=1
                    end do
                endif
            end do
        end do
    endif
    if (lcontx) then
        do i = 1, nnes
            if (lact(i) .eq. 0) then
! --- CONTACT NON ACTIF POUR CE NOEUD, ON ELIMINE LES DDL DE CONTACT
                do j = 1, ndim
                    if (.not.lmulti) posddl(ddles*i-ndim+j)=1
                    if (lmulti) posddl(ddles*(i-1)+ndim*(nfhe+heavno(i)) +j)=1
                end do
            endif
        end do
    endif
!
! --- POUR LES OPTIONS RELATIVES AUX MATRICES
    if (lmat) then
! --- CALCUL DU COEFFICIENT DIAGONAL POUR
! --- L'ELIMINATION DES DDLS HEAVISIDE
! --- MISE A ZERO DES TERMES HORS DIAGONAUX (I,J)
! --- ET MISE A UN DES TERMES DIAGONAUX (I,I)
!        DMIN=R8MAEM()
        dmax=1.d0
        do i = 1, nddl
            if (posddl(i) .eq. 0) cycle
            do j = 1, nddl
                if (j .ne. i) then
                    mmat(i,j) = 0.d0
                    mmat(j,i) = 0.d0
                endif
                if (j .eq. i) mmat(i,j) = dmax
            end do
        end do
!
! --- POUR LES OPTIONS RELATIVES AUX VECTEURS
    else if (lvec) then
! --- MISE A ZERO DES TERMES I
        do i = 1, nddl
            if (posddl(i) .eq. 0) cycle
            vtmp(i) = 0.d0
        end do
    endif
!
end subroutine
