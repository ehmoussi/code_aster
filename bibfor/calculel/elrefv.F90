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
!
subroutine elrefv(fami    , ndim    ,&
                  nnoL    , nnoQ    , nnos,&
                  npg     , jv_poids,&
                  jv_vfL  , jv_vfQ  ,&
                  jv_dfdeL, jv_dfdeQ,&
                  jv_ganoL, jv_ganoQ)
!
implicit none
!
#include "asterfort/elref1.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
!
character(len=4), intent(in) :: fami
integer, intent(out) :: ndim, nnos
integer, intent(out) :: npg, jv_poids
integer, intent(out) :: nnoL, jv_vfL, jv_dfdeL, jv_ganoL
integer, intent(out) :: nnoQ, jv_vfQ, jv_dfdeQ, jv_ganoQ
!
! ---------------------------------------------------------------------
! BUT: RECUPERER DANS UNE ROUTINE TE00IJ LES ADRESSES DANS ZR
!      - DES POIDS DES POINTS DE GAUSS  : IPOIDS
!      - DES VALEURS DES FONCTIONS DE FORME : IVF
!      - DES VALEURS DES DERIVEES 1ERES DES FONCTIONS DE FORME : IDFDE
!      - DE LA MATRICE DE PASSAGE GAUSS -> NOEUDS : JGANO
! ---------------------------------------------------------------------
!   IN   NOMTE        -->  NOM DU TYPE ELEMENT
!        FAMIL  : NOM (LOCAL) DE LA FAMILLE DE POINTS DE GAUSS :
!                 'STD','RICH',...
!   OUT  NDIM   : DIMENSION DE L'ESPACE (=NB COORDONNEES)
!        NNO    : NOMBRE DE NOEUDS DU TYPE_MAILLE 1
!                 (DEPLACEMENT QUADRATIQUE)
!        NNO2   : NOMBRE DE NOEUDS DU TYPE_MAILLE 2
!                 (VARIABLE INETERNE + LAGRANGE LINEAIRE)
!        NNOS   : NOMBRE DE NOEUDS SOMMETS DU TYPE_MAILLE
!        NPG    : NOMBRE DE POINTS DE GAUSS
!        IPOIDS : ADRESSE DANS ZR DU TABLEAU POIDS(IPG)
!        IVF    : ADRESSE DANS ZR DU TABLEAU FF(INO,IPG) TYPE_MAILLE 1
!        IVF2   : ADRESSE DANS ZR DU TABLEAU FF(INO2,IPG) TYPE_MAILLE 2
!        IDFDE  : ADRESSE DANS ZR DU TABLEAU DFF(IDIM,INO,IPG)
!        IDFDE2 : ADRESSE DANS ZR DU TABLEAU DFF(IDIM,INO2,IPG)
!        JGANO  : ADRESSE DANS ZR DE LA MATRICE DE PASSAGE
!                      GAUSS -> NOEUDS (DIM= 2+NNO*NPG)
!                 ATTENTION : LES 2 1ERS TERMES SONT LES
!                             DIMMENSIONS DE LA MATRICE: NNO ET NPG
!        JGANO2  : ADRESSE DANS ZR DE LA MATRICE DE PASSAGE
!                      GAUSS -> NOEUDS (DIM= 2+NNO2*NPG)
!                 ATTENTION : LES 2 1ERS TERMES SONT LES
!                             DIMMENSIONS DE LA MATRICE: NNO2 ET NPG
!   -------------------------------------------------------------------
    character(len=8) :: elrefeL, elrefeQ
!
! - Get ELREFE (quadratic)
!
    call elref1(elrefeQ)
!
! - Get pointer for quadratic elrefe
!
    call elrefe_info(elrefe = elrefeQ, fami   = fami    , &
                     ndim   = ndim   , nno    = nnoQ    , nnos  = nnos    ,&
                     npg    = npg    , jpoids = jv_poids,&
                     jvf    = jv_vfQ , jdfde  = jv_dfdeQ, jgano = jv_ganoQ)
!
! - Get ELREFE (linear)
!
    if (elrefeQ .eq. 'TR3' .or. elrefeQ .eq. 'QU4') then
! ----- Already linear
        elrefeL = elrefeQ
    else
! ----- Find linear support
        if (elrefeQ .eq. 'TR6') then
            elrefeL = 'TR3'
        else if (elrefeQ .eq. 'QU8') then
            elrefeL = 'QU4'
        else if (elrefeQ .eq. 'H20') then
            elrefeL = 'HE8'
        else if (elrefeQ .eq. 'T10') then
            elrefeL = 'TE4'
        else if (elrefeQ .eq. 'P15') then
            elrefeL = 'PE6'
        else if (elrefeQ .eq. 'S15') then
            elrefeL = 'SH6'
        else if (elrefeQ .eq. 'P13') then
            elrefeL = 'PY5'
        else
            WRITE(6,*) 'No linear reference: ',elrefeQ
            ASSERT(ASTER_FALSE)
        endif
    endif
!
! - Get pointers for linear elrefe
!
    call elrefe_info(elrefe = elrefeL, fami   = fami    , &
                     ndim   = ndim   , nno    = nnoL    , nnos  = nnos    ,&
                     npg    = npg    , jpoids = jv_poids,&
                     jvf    = jv_vfL , jdfde  = jv_dfdeL, jgano = jv_ganoL)
!
end subroutine
