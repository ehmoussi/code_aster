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

subroutine te0313(option, nomte)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/ismaem.h"
#include "asterfort/aseihm.h"
#include "asterfort/caeihm.h"
#include "asterfort/eiangl.h"
#include "asterfort/fneihm.h"
#include "asterfort/jevech.h"
#include "asterfort/poeihm.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/Behaviour_type.h"
    character(len=16) :: option, nomte
!
!
! =====================================================================
!    - FONCTION REALISEE: FULL_MECA, RIGI_MECA, RAPH_MECA, FORC_NODA
!                         VARI_ELNO,SIEF_ELNO
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! =====================================================================
    integer :: jgano, imatuu, ndim, imate, iinstm, jcret, ncmp, nvim
    integer :: iret, ichg, ichn, itabin(7), itabou(7)
    integer :: ivf2
    integer :: idf2, npi, npg
    integer :: retloi, iretp, iretm
    integer :: ipoids, ivf1, idf1, igeom
    integer :: iinstp, ideplm, ideplp, icompo, icamas
    integer :: icontm, ivarip, ivarim, ivectu, icontp
!
! =====================================================================
! =====================================================================
!
    integer :: mecani(8), press1(9), press2(9), tempe(5), dimuel
    integer :: dimdef, dimcon, nbvari
    integer :: nno1, nno2
    integer :: iadzi, iazk24
    integer :: iu(3, 18), ip(2, 9), ipf(2, 2, 9), iq(2, 2, 9)
    real(kind=8) :: r(22)
    real(kind=8) :: ang(24)
    character(len=3) :: modint
    character(len=8) :: nomail
!
! =====================================================================
    integer :: li
    aster_logical :: axi, perman
!
! =====================================================================
! AXI       AXISYMETRIQUE?
! PERMAN    REGIME PERMANENT ?
! NNO1      NB DE NOEUDS DES BORDS INF ET SUP DE L'ELEMENT
! NNO2      NB DE NOEUDS DU SEGEMENT CENTRAL DE L'ELEMENT
! NPI       NB DE POINTS D'INTEGRATION DE L'ELEMENT
! NPG       NB DE POINTS DE GAUSS     POUR CLASSIQUE(=NPI)
! NDIM      DIMENSION DE L'ESPACE
! DIMUEL    NB DE DDL TOTAL DE L'ELEMENT
! DIMCON    DIMENSION DES CONTRAINTES GENERALISEES ELEMENTAIRES
! DIMDEF    DIMENSION DES DEFORMATIONS GENERALISEES ELEMENTAIRES
! NBVARI    NB DE VARIABLES INTERNES
! IU        DECALAGE D'INDICE POUR ACCEDER AUX DDL DE DEPLACEMENT
! IP        DECALAGE D'INDICE POUR ACCEDER AUX DDL DE PRESSION MILIEU
! IPF       DECALAGE D'INDICE POUR ACCEDER AUX DDL DE PRESSION FACES
! IQ        DECALAGE D'INDICE POUR ACCEDER AUX DDL DE LAGRANGE HYDRO
! ANG       ANGLES NAUTIQUES POUR ORIENTATION ELEMENT
! MODINT    MODE D'INTEGRATION
! NOMAIL    NUMERO DE MAILLE
! IVF       FONCTIONS DE FORMES QUADRATIQUES
! IVF2      FONCTIONS DE FORMES LINEAIRES
! =====================================================================
    aster_logical :: fnoevo
    real(kind=8) :: dt
!
! =====================================================================
! --- 1. INITIALISATIONS ----------------------------------------------
! --- SUIVANT ELEMENT, DEFINITION DES CARACTERISTIQUES : --------------
! --- CHOIX DU TYPE D'INTEGRATION -------------------------------------
! --- RECUPERATION DE LA GEOMETRIE ET POIDS DES POINTS D'INTEGRATION --
! --- RECUPERATION DES FONCTIONS DE FORME -----------------------------
! =====================================================================
!
!
! - Init THM module
!
    call thmModuleInit()
!
! - Get model of finite element
!
    call thmGetElemModel()
    if (ds_thm%ds_elem%l_weak_coupling) then
        call utmess('F', 'CHAINAGE_12')
    endif
!
! - Preparation
!
    call caeihm(nomte, axi, perman, mecani, press1,&
                press2, tempe, dimdef, dimcon, ndim,&
                nno1, nno2, npi, npg, dimuel,&
                ipoids, ivf1, idf1, ivf2, idf2,&
                jgano, iu, ip, ipf, iq,&
                modint)
!
    call tecael(iadzi, iazk24)
    nomail = zk24(iazk24-1+3) (1:8)
!
! RECUPERATION DES ANGLES NAUTIQUES DEFINIS PAR AFFE_CARA_ELEM
    if ((option .eq. 'FORC_NODA') .or. (option(1:9).eq.'RIGI_MECA' ) .or.&
        (option(1:9).eq.'RAPH_MECA' ) .or. (option(1:9).eq.'FULL_MECA' )) then
!
        call jevech('PCAMASS', 'L', icamas)
        if (zr(icamas) .eq. -1.d0) then
            call utmess('F', 'ELEMENTS5_48')
        endif
!
! DEFINITION DES ANGLES NAUTIQUES AUX NOEUDS SOMMETS
        call eiangl(ndim, nno2, zr(icamas+1), ang)
    endif
! =====================================================================
! --- DEBUT DES DIFFERENTES OPTIONS -----------------------------------
! =====================================================================
! --- 2. OPTIONS : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA -------------
! =====================================================================
    if ((option(1:9).eq.'RIGI_MECA' ) .or. (option(1:9).eq.'RAPH_MECA' ) .or.&
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
        call jevech('PVARIMR', 'L', ivarim)
        call jevech('PCONTMR', 'L', icontm)
!
        read (zk16(icompo-1+NVAR),'(I16)') nbvari
! =====================================================================
! --- PARAMETRES EN SORTIE ISMAEM? ------------------------------------
! =====================================================================
        if (option(1:9) .eq. 'RIGI_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
            call jevech('PMATUNS', 'E', imatuu)
        else
            imatuu = ismaem()
        endif
!
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
!
        retloi = 0
!
!
        if (option(1:9) .eq. 'RIGI_MECA') then
            call aseihm(option, axi, ndim, nno1, nno2,&
                        npi, npg, dimuel, dimdef, dimcon,&
                        nbvari, zi(imate), iu, ip, ipf,&
                        iq, mecani, press1, press2, tempe,&
                        zr(ivf1), zr(ivf2), zr(idf2), zr(iinstm), zr(iinstp),&
                        zr(ideplm), zr(ideplm), zr(icontm), zr(icontm), zr(ivarim),&
                        zr(ivarim), nomail, zr(ipoids), zr(igeom), ang,&
                        zk16(icompo), perman, zr(ivectu), zr(imatuu),&
                        retloi)
        else
            do li = 1, dimuel
                zr(ideplp+li-1) = zr(ideplm+li-1) + zr(ideplp+li-1)
            end do
            call aseihm(option, axi, ndim, nno1, nno2,&
                        npi, npg, dimuel, dimdef, dimcon,&
                        nbvari, zi(imate), iu, ip, ipf,&
                        iq, mecani, press1, press2, tempe,&
                        zr(ivf1), zr(ivf2), zr(idf2), zr(iinstm), zr(iinstp),&
                        zr(ideplm), zr(ideplp), zr(icontm), zr(icontp), zr(ivarim),&
                        zr(ivarip), nomail, zr(ipoids), zr(igeom), ang,&
                        zk16(icompo), perman, zr(ivectu), zr(imatuu),&
                        retloi)
!
            zi(jcret) = retloi
        endif
!
    endif
!
! ======================================================================
! --- 3. OPTION : FORC_NODA --------------------------------------------
! ======================================================================
    if (option .eq. 'FORC_NODA') then
! ======================================================================
! --- PARAMETRES EN ENTREE ---------------------------------------------
! ======================================================================
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PMATERC', 'L', imate)
! ======================================================================
! --- SI LES TEMPS PLUS ET MOINS SONT PRESENTS -------------------------
! --- C EST QUE L ON APPELLE DEPUIS STAT NON LINE ET -------------------
! --- ALORS LES TERMES DEPENDANT DE DT SONT EVALUES --------------------
! ======================================================================
        call tecach('ONO', 'PINSTMR', 'L', iretm, iad=iinstm)
        call tecach('ONO', 'PINSTPR', 'L', iretp, iad=iinstp)
        if (iretm .eq. 0 .and. iretp .eq. 0) then
            dt = zr(iinstp) - zr(iinstm)
            fnoevo = .true.
        else
            fnoevo = .false.
            dt = 0.d0
        endif
!
! ======================================================================
! --- PARAMETRES EN SORTIE ---------------------------------------------
! ======================================================================
        call jevech('PVECTUR', 'E', ivectu)
!
        call fneihm(fnoevo, dt, perman, nno1, nno2,&
                    npi, npg, zr(ipoids), iu, ip,&
                    ipf, iq, zr(ivf1), zr(ivf2), zr(idf2),&
                    zr(igeom), ang, zr( icontm), r, zr(ivectu),&
                    mecani, press1, press2, tempe, dimdef,&
                    dimcon, dimuel, ndim, axi)
!
    endif
!
! ======================================================================
! --- 4. OPTION : SIEF_ELNO ---------------------------------------
! ======================================================================
    if (option .eq. 'SIEF_ELNO') then
        call jevech('PCONTRR', 'L', ichg)
        call jevech('PSIEFNOR', 'E', ichn)
!
!
        nvim=mecani(6)
!
        call poeihm(nomte, option, modint, jgano, nno1,&
                    nno2, dimcon, nvim, zr(ichg), zr(ichn))
    endif
!
! ======================================================================
! --- 5. OPTION : VARI_ELNO ---------------------------------------
! ======================================================================
    if (option .eq. 'VARI_ELNO') then
        call tecach('OOO', 'PVARIGR', 'L', iret, nval=7,&
                    itab=itabin)
        call tecach('OOO', 'PVARINR', 'E', iret, nval=7,&
                    itab=itabou)
        ichg=itabin(1)
        ichn=itabou(1)
!
        call jevech('PCOMPOR', 'L', icompo)
        read (zk16(icompo-1+NVAR),'(I16)') ncmp
        read (zk16(icompo-1+MECA_NVAR),'(I16)') nvim
!
        call poeihm(nomte, option, modint, jgano, nno1,&
                    nno2, ncmp, nvim, zr(ichg), zr(ichn))
    endif
!
! ======================================================================
end subroutine
