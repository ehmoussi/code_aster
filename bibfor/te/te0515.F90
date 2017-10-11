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

subroutine te0515(option, nomte)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/ismaem.h"
#include "asterfort/assert.h"
#include "asterfort/assesu.h"
#include "asterfort/thmGetElemDime.h"
#include "asterfort/thmGetGene.h"
#include "asterfort/fnoesu.h"
#include "asterfort/jevech.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/elrefe_info.h"
!
character(len=16) :: option, nomte
!    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
!                          ELEMENTS HH2_SUDA, (SUSHI DECENTRE ARRETE)
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! =====================================================================
    integer :: nno, imatuu, ndim, imate, iinstm, jcret
    integer :: nnom
    integer :: retloi
    integer :: igeom
    integer :: iinstp, ideplm, ideplp, icompo, icarcr
    integer :: icontm, ivarip, ivarim, ivectu, icontp
! =====================================================================
    integer :: mecani(5), press1(7), press2(7), tempe(5), dimuel
    integer :: dimdep, dimdef, dimcon, nbvari, nddls, nddlm
    integer :: nddl_meca, nddl_p1, nddl_p2, nnos, nddlk, nddlfa
    integer :: nface
!     REMARQUE : CES DIMENSIONS DOIVENT ETRE LES MEMES QUE DANS TE0492
    real(kind=8) :: defgep(21), defgem(21)
    integer :: nconma, ndefma
    parameter (nconma=31,ndefma=21)
    real(kind=8) :: dsde(nconma, ndefma)
    character(len=8) :: type_elem(2)
! =====================================================================
    integer :: li
    aster_logical :: l_axi, l_steady, l_vf
    character(len=8) :: elrefe, elref2
! =====================================================================
!  CETTE ROUTINE FAIT UN CALCUL EN HH2SUDA OU HH2SUC, (HYDRO NON SATURE
!   SUSHI DECENTRE ARETE OU CENTRE)
! =====================================================================
!  POUR LES TABLEAUX DEFGEP ET DEFGEM ON A DANS L'ORDRE :
!                                      PRE1 P1DX P1DY P1DZ
!                                      PRE2 P2DX P2DY P2DZ
! =====================================================================
!    POUR LES CHAMPS DE CONTRAINTE
!                                      M11 FH11X FH11Y FH11Z
!                                      ENT11
!                                      M12 FH12X FH12Y FH12Z
!                                      ENT12
!                                      M21 FH21X FH21Y FH21Z
!                                      ENT21
!                                      M22 FH22X FH22Y FH22Z
!                                      ENT22
! TYPMOD    MODELISATION (D_PLAN, 3D )
! MODINT    METHODE D'INTEGRATION (CLASSIQUE,LUMPEE(D),REDUITE(R) ?)

! NDDLK     NB DDL AU CENTRE ELEMENT
! NDIM      DIMENSION DE L'ESPACE
! DIMUEL    NB DE DDL TOTAL DE L'ELEMENT
! DIMCON    DIMENSION DES CONTRAINTES GENERALISEES ELEMENTAIRES
! DIMDEF    DIMENSION DES DEFORMATIONS GENERALISEES ELEMENTAIRES
! IVF       FONCTIONS DE FORMES QUADRATIQUES
! IVF2      FONCTIONS DE FORMES LINEAIRES
! =====================================================================
! =====================================================================
! --- 1. INITIALISATIONS ----------------------------------------------
! --- SUIVANT ELEMENT, DEFINITION DES CARACTERISTIQUES : --------------
! --- CHOIX DU TYPE D'INTEGRATION -------------------------------------
! --- RECUPERATION DE LA GEOMETRIE ET POIDS DES POINTS D'INTEGRATION --
! --- RECUPERATION DES FONCTIONS DE FORME -----------------------------
! =====================================================================
!
! - Init THM module
!
    call thmModuleInit()
!
! - Get model of finite element
!
    call thmGetElemModel(l_axi, l_vf, l_steady, ndim_ = ndim, type_elem_ = type_elem)
    ASSERT(l_vf)
    ASSERT(.not. l_steady)
!
! - Get informations about element
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
    call elrefe_info(elrefe=elrefe, fami='RIGI', nno=nno, nnos=nnos)
    nnom = nno - nnos
    if (ndim .eq. 2) then
        nface = nnos
    else
        if (elrefe .eq. 'H27') then
            nface = 6
        else if (elrefe .eq. 'T9') then
            nface = 4
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
!
! - Get generalized coordinates
!
    call thmGetGene(l_steady, l_vf, ndim,&
                    mecani  , press1, press2, tempe)
!
! - Get all parameters for current element
!
    call thmGetElemDime(ndim     , nnos   , nnom   ,&
                        mecani   , press1 , press2 , tempe ,&
                        nddls    , nddlm  , &
                        nddl_meca, nddl_p1, nddl_p2,&
                        dimdep   , dimdef , dimcon , dimuel)
    nddls  = 0
    nddlm  = 0
    nddlk  = press1(1) + press2(1) + tempe(1)
    nddlfa = press1(1) + press2(1) + tempe(1)
    dimuel = nnos*nddls + nface*nddlfa + nddlk
    
! =====================================================================
! --- DEBUT DES DIFFERENTES OPTIONS -----------------------------------
! =====================================================================
! --- 2. OPTIONS : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA -------------
! =====================================================================
    if ((option(1:14).eq.'RIGI_MECA_TANG' ) .or. (option(1:9).eq.'RAPH_MECA' ) .or.&
        (option(1:9).eq.'FULL_MECA' )) then
! =====================================================================
! --- PARAMETRES EN ENTREE --------------------------------------------
! =====================================================================
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PMATERC', 'L', imate)
        call jevech('PINSTMR', 'L', iinstm)
        call jevech('PINSTPR', 'L', iinstp)
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        call jevech('PCOMPOR', 'L', icompo)
        call jevech('PCARCRI', 'L', icarcr)
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PCONTMR', 'L', icontm)
        read (zk16(icompo-1+2),'(I16)') nbvari
! =====================================================================
! --- PARAMETRES EN SORTIE ISMAEM? ------------------------------------
! =====================================================================
        if ((option(1:14).eq.'RIGI_MECA_TANG' ) .or. option(1:9) .eq. 'FULL_MECA') then
            call jevech('PMATUNS', 'E', imatuu)
        else
            imatuu = ismaem()
        endif
        if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
            call jevech('PVECTUR', 'E', ivectu)
            call jevech('PCONTPR', 'E', icontp)
            call jevech('PVARIPR', 'E', ivarip)
            call jevech('PCODRET', 'E', jcret)
            zi(jcret) = 0
        else
            ivectu = ismaem()
            icontp = ismaem()
            ivarip = ismaem()
        endif
        retloi = 0
        if (option(1:14) .eq. 'RIGI_MECA_TANG') then
            call assesu(nno, nnos, nface, zr(igeom), zr(icarcr),&
                        zr( ideplm), zr(ideplm), zr(icontm), zr(icontm), zr(ivarim),&
                        zr( ivarim), defgem, defgem, dsde, zr(imatuu),&
                        zr(ivectu), zr(iinstm), zr(iinstp), option, zi(imate),&
                        mecani, press1, press2, tempe, dimdef,&
                        dimcon, dimuel, nbvari, ndim, zk16( icompo),&
                        type_elem, l_axi, l_steady)
        else
!
!   DU FAIT DE L UTIISATION DES VOISINS CETTE BOUCLE
!  NE PEUT PLUS ETRE FAITECONTRAIREMENT A LA SITUATION EF
!  ASSESU UTILISE DELTAP ET PM
            do li = 1, dimuel
                zr(ideplp+li-1) = zr(ideplm+li-1) + zr(ideplp+li-1)
            end do
            call assesu(nno, nnos, nface, zr(igeom), zr(icarcr),&
                        zr( ideplm), zr(ideplp), zr(icontm), zr(icontp), zr(ivarim),&
                        zr( ivarip), defgem, defgep, dsde, zr(imatuu),&
                        zr(ivectu), zr(iinstm), zr(iinstp), option, zi(imate),&
                        mecani, press1, press2, tempe, dimdef,&
                        dimcon, dimuel, nbvari, ndim, zk16( icompo),&
                        type_elem, l_axi, l_steady)
            zi(jcret) = retloi
        endif
    endif
! ======================================================================
! --- 6. OPTION : FORC_NODA --------------------------------------------
! ======================================================================
    if (option .eq. 'FORC_NODA') then
! ======================================================================
! --- PARAMETRES EN ENTREE ---------------------------------------------
! ======================================================================
        call jevech('PCONTMR', 'L', icontm)
! ======================================================================
! --- PARAMETRES EN SORTIE ---------------------------------------------
! ======================================================================
        call jevech('PVECTUR', 'E', ivectu)
        call fnoesu(option, nface,&
                    zr(icontm), zr(ivectu), press1, press2,&
                    dimcon, dimuel)
    endif
! ======================================================================
end subroutine
