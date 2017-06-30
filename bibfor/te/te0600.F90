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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine te0600(option, nomte)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmCompEpsiElga.h"
#include "asterfort/thmCompSiefElno.h"
#include "asterfort/thmCompVariElno.h"
#include "asterfort/thmCompRefeForcNoda.h"
#include "asterfort/thmCompForcNoda.h"
#include "asterfort/thmCompLoad.h"
#include "asterfort/thmCompGravity.h"
#include "asterfort/thmCompNonLin.h"
#include "asterfort/Behaviour_type.h"

    character(len=16) :: option, nomte
! =====================================================================
!    - FONCTION REALISEE:  CALCUL DES OPTIONS NON-LINEAIRES MECANIQUES
!                          ELEMENTS THHM, HM ET HH
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! =====================================================================
    integer :: ndim
    integer :: mecani(5), press1(7), press2(7), tempe(5)
    character(len=3) :: modint
    integer :: typvf
    aster_logical :: axi, perman, vf
! =====================================================================
!  CETTE ROUTINE FAIT UN CALCUL EN THHM , HM , HHM , THH
!  21 = 9 DEF MECA + 4 POUR P1 + 4 POUR P2 + 4 POUR T
!  31 = 7 MECA + 2*5 POUR P1 + 2*5 POUR P2 + 4 POUR T
! =====================================================================
!  POUR LES TABLEAUX DEFGEP ET DEFGEM ON A DANS L'ORDRE :
!                                      DX DY DZ
!                                      EPXX EPYY EPZZ EPXY EPXZ EPYZ
!                                      PRE1 P1DX P1DY P1DZ
!                                      PRE2 P2DX P2DY P2DZ
!                                      TEMP TEDX TEDY TEDZ
!            EPSXY = RAC2/2*(DU/DY+DV/DX)
! =====================================================================
!    POUR LES CHAMPS DE CONTRAINTE
!                                      SIXX SIYY SIZZ SIXY SIXZ SIYZ
!                                      SIPXX SIPYY SIPZZ SIPXY SIPXZ SIP
!                                      M11 FH11X FH11Y FH11Z
!                                      ENT11
!                                      M12 FH12X FH12Y FH12Z
!                                      ENT12
!                                      M21 FH21X FH21Y FH21Z
!                                      ENT21
!                                      M22 FH22X FH22Y FH22Z
!                                      ENT22
!                                      QPRIM FHTX FHTY FHTZ
!        SIXY EST LE VRAI DE LA MECANIQUE DES MILIEUX CONTINUS
!        DANS EQUTHM ON LE MULITPLIERA PAR RAC2
! =====================================================================
!   POUR L'OPTION FORCNODA
!  SI LES TEMPS PLUS ET MOINS SONT PRESENTS
!  C'EST QUE L'ON APPELLE DEPUIS STAT NON LINE  : FNOEVO = VRAI
!  ET ALORS LES TERMES DEPENDANT DE DT SONT EVALUES
!  SI LES TEMPS PLUS ET MOINS NE SONT PAS PRESENTS
!  C'EST QUE L'ON APPELLE DEPUIS CALCNO  : FNOEVO = FAUX
!  ET ALORS LES TERMES DEPENDANT DE DT NE SONT PAS EVALUES
! =====================================================================
! AXI       AXISYMETRIQUE?
! TYPMOD    MODELISATION (D_PLAN, AXI, 3D ?)
! MODINT    METHODE D'INTEGRATION (CLASSIQUE,LUMPEE(D),REDUITE(R) ?)
! NNO       NB DE NOEUDS DE L'ELEMENT
! NNOS      NB DE NOEUDS SOMMETS DE L'ELEMENT
! NNOM      NB DE NOEUDS MILIEUX DE L'ELEMENT
! NDDLS     NB DE DDL SUR LES SOMMETS
! NDDLM     NB DE DDL SUR LES MILIEUX
! NPI       NB DE POINTS D'INTEGRATION DE L'ELEMENT
! NPG       NB DE POINTS DE GAUSS     POUR CLASSIQUE(=NPI)
!                 SOMMETS             POUR LUMPEE   (=NPI=NNOS)
!                 POINTS DE GAUSS     POUR REDUITE  (<NPI)
! NDIM      DIMENSION DE L'ESPACE
! DIMUEL    NB DE DDL TOTAL DE L'ELEMENT
! DIMCON    DIMENSION DES CONTRAINTES GENERALISEES ELEMENTAIRES
! DIMDEF    DIMENSION DES DEFORMATIONS GENERALISEES ELEMENTAIRES
! IVF       FONCTIONS DE FORMES QUADRATIQUES
! IVF2      FONCTIONS DE FORMES LINEAIRES
! =====================================================================

!
! - Init THM module
!
    call thmModuleInit()
!
! - Get model of finite element
!
    call thmGetElemModel()

! =====================================================================
! --- 2. OPTIONS : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA -------------
! =====================================================================
    if ((option(1:9).eq.'RIGI_MECA' ) .or. (option(1:9).eq.'RAPH_MECA' ) .or.&
        (option(1:9).eq.'FULL_MECA' )) then
        call thmCompNonLin(option)
    endif
! =====================================================================
! --- 3. OPTION : CHAR_MECA_PESA_R ------------------------------------
! =====================================================================
    if (option .eq. 'CHAR_MECA_PESA_R') then
        call thmCompGravity(modint, axi , vf  , typvf, ndim,&
                            mecani, press1, press2, tempe)
    endif
!
! =====================================================================
! --- 4. OPTIONS : CHAR_MECA_FR2D2D OU CHAR_MECA_FR3D3D ---------------
! =====================================================================
    if (option .eq. 'CHAR_MECA_FR3D3D' .or. option .eq. 'CHAR_MECA_FR2D2D') then
        call thmCompLoad(option, nomte,&
                         axi   , modint, vf    , typvf, ndim,&
                         mecani, press1, press2, tempe)
    endif
! ======================================================================
! --- 5. OPTION : FORC_NODA --------------------------------------------
! ======================================================================
    if (option .eq. 'FORC_NODA') then
        call thmCompForcNoda(axi   , modint, vf    , typvf, perman, ndim ,&
                             mecani, press1, press2, tempe)
    endif
! ======================================================================
! --- 6. OPTION : REFE_FORC_NODA ---------------------------------------
! ======================================================================
    if (option .eq. 'REFE_FORC_NODA') then
        call thmCompRefeForcNoda(axi   , modint, vf    , typvf, perman, ndim ,&
                                 mecani, press1, press2, tempe)
    endif
! ======================================================================
! --- 7. OPTION : SIEF_ELNO --------------------------------------------
! ======================================================================
    if (option .eq. 'SIEF_ELNO  ') then
        call thmCompSiefElno(vf, modint, mecani, press1, press2, tempe)
    endif
! ======================================================================
! --- 8. OPTION : VARI_ELNO --------------------------------------------
! ======================================================================
    if (option .eq. 'VARI_ELNO  ') then
        call thmCompVariElno(vf, modint)
    endif
! ======================================================================
! --- 9. OPTION : EPSI_ELGA --------------------------------------------
! ======================================================================
    if (option .eq. 'EPSI_ELGA') then
        call thmCompEpsiElga(vf, axi, modint, ndim,&
                             mecani, press1, press2, tempe)
    endif
!
end subroutine
