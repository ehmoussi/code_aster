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
! aslint: disable=W1501,W1504,W1306
!
subroutine assesu(option   , j_mater  ,&
                  type_elem, &
                  ndim     , nbvari   ,&
                  nno      , nnos     , nface ,&
                  dimdef   , dimcon   , dimuel,&
                  mecani   , press1   , press2, tempe,&
                  compor   , carcri   ,&
                  elem_coor,&
                  dispm    , dispp    ,&
                  defgem   , defgep   ,& 
                  congem   , congep   ,&
                  vintm    , vintp    ,&
                  time_prev, time_curr,& 
                  matuu    , vectu)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/cabhvf.h"
#include "asterfort/cacdsu.h"
#include "asterfort/cafmes.h"
#include "asterfort/cafves.h"
#include "asterfort/comthm_vf.h"
#include "asterfort/inices.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterfort/vfcfks.h"
#include "asterfort/thmGetBehaviour.h"
#include "asterfort/thmGetBehaviourVari.h"
#include "asterfort/thmGetParaInit.h"
#include "asterfort/THM_type.h"
!
integer, parameter :: maxfa=6
character(len=16), intent(in) :: option
integer, intent(in) :: j_mater
character(len=8), intent(in) :: type_elem(2)
integer, intent(in) :: ndim, nbvari
integer, intent(in) :: nno, nnos, nface
integer, intent(in) :: dimdef, dimcon, dimuel
integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
character(len=16), intent(in)  :: compor(*)
real(kind=8), intent(in) :: carcri(*)
real(kind=8), intent(in) :: elem_coor(ndim, nno)
real(kind=8), intent(in) :: dispm(dimuel), dispp(dimuel)
real(kind=8), intent(inout) :: defgem(dimdef), defgep(dimdef)
real(kind=8), intent(in) :: congem(dimcon, maxfa+1)
real(kind=8), intent(inout) :: congep(dimcon, maxfa+1)
real(kind=8), intent(in) :: vintm(nbvari, maxfa+1)
real(kind=8), intent(inout) :: vintp(nbvari, maxfa+1)
real(kind=8), intent(in) :: time_curr, time_prev 
real(kind=8), intent(inout) :: matuu(dimuel*dimuel)
real(kind=8), intent(inout) :: vectu(dimuel)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Compute non-linear options - General assembling for all physics (finite volume)
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  j_mater          : coded material address
! In  l_axi            : flag is axisymmetric model
! In  type_elem        : type of modelization (TYPMOD2)
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  nno              : total number of nodes
! In  nnos             : number of nodes (not middle ones)
! In  nface            : number of faces (for finite volume)
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  dimuel           : number of dof for element
! In  mecani           : parameters for mechanic
! In  press1           : parameters for hydraulic (capillary pressure)
! In  press2           : parameters for hydraulic (gaz pressure)
! In  tempe            : parameters for thermic
! In  compor           : behaviour
! In  carcri           : parameters for comportment
! In  elem_coor        : coordinates of node for current element
! In  dispm            : displacements - At begin of current step
! In  dispp            : displacements - At end of current step
! IO  defgem           : generalized strains - At begin of current step
! IO  defgep           : generalized strains - At end of current step
! In  congem           : generalized stresses - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! In  vintm            : internal state variables - At begin of current step
! IO  vintp            : internal state variables - At end of current step
! In  time_prev        : time at beginning of step
! In  time_curr        : time at end of step
! IO  matuu            : tangent matrix
! IO  vectu            : non-linear forces
!
! --------------------------------------------------------------------------------------------------
!

! PCP PRESSION CAPILLAIRE AU CENTRE DE LA MAILLE
! PWP PRESSION EAU
! DPWP1 DERIVEE PRESSION EAU PAR P1
! DPWP2 DERIVEE PRESSION EAU PAR P2
! PGP PRESSION DE GAZ AU CENTRE DE LA MAILLE
! CVP CONCENTRATION VAPEUR DANS PHASE GAZEUSE
! DCVP1 DERIVEE CVP /P1
! DCVP2 DERIVEE CVP /P2
! CAD ENTRATION AIR DISSOUS
! DCAD1 DERIVEE CAD /P1
! DCAD2 DERIVEE CAD /P2
!  VALFAC(I,CON,WLIQ)     CONCENTRATION DE L EAU LIQUIDE SUR ARRETE I
!  VALFAC(I,DCONP1,WLIQ)  D_CON_EAU_LIQU_I /P1
!  VALFAC(I,DCONP2,WLIQ)  D_CON_EAU_LIQU_I /P2
!  VALFAC(I,DIFFU,WLIQ)   DIFFUW SUR ARETE I
!  VALFAC(I,DDIFP1,WLIQ)  D_DIFFUW_I /P1
!  VALFAC(I,DDIFP2,WLIQ)  D_DIFFUW_I /P2
!  VALFAC(I,MOB,WLIQ)     MOBILITE DE L EAU LIQUIDE SUR ARETE I
!  VALFAC(I,DMOBP1,WLIQ)  D_MO_LIQU /P1_CENTRE
!  VALFAC(I,DMOBP2,WLIQ)  D_MO_LIQU /P2_CENTRE
! NB: DE MEME POUR WVAP(EAU VAPEUR),AIRDIS(AIR DISSOUS),AIRSEC(AIR SEC)
!  VALCEN(CON,WVAP)       CONCENTRATION EAU VAPEUR
!  VALCEN(DCONP1,WVAP)
!  VALCEN(DCONP2,WVAP)
! etc...
! =====================================================================
! VARIABLES LOCALES POUR CALCULS VF SUSHI
! =====================================================================
! PCPF PRESSION CAPILLAIRE SUR LA FACE
! PGPF PRESSION DE GAZ SUR LA FACE
! DPGP1F DERIVEE DE PRESSION DE GAZ /P1 SUR LA FACE
! DZGP2F DERIVEE DE PRESSION DE GAZ /P2 SUR LA FACE
! PWPF PRESSION EAU SUR LA FACE
! DPWP1F DERIVEE DE PRESSION EAU /P1 SUR LA FACE
! DPWP2F DERIVEE DE PRESSION EAU /P2 SUR LA FACE
! CVPF CONCENTRATION VAPEUR DANS PHASE GAZEUSE SUR LA FACE
! DCVP1F DERIVEE CVP /P1 SUR LA FACE
! DCVP2F DERIVEE CVP /P2 SUR LA FACE
! CADF CONCENTRATION AIR DISSOUS SUR LA FACE
! DCAD1F DERIVEE CAD /P1 SUR LA FACE
! DCAD2F DERIVEE CAD /P2 SUR LA FACE
! VALCEN(MOB,WLIQ) MOBILITE EAU SUR FACE
! VALCEN(DMOBP1,WLIQ) DERIVEE MOBILITE EAU /P1 SUR K
! VALCEN(DMOBP2,WLIQ) DERIVEE MOBILITE EAU /P2 SUR K
! etc ...
! DASP1F DERIVEE MOBILITE AIR SEC /P1 SUR FACE
! DASP2F DERIVEE MOBILITE AIR SEC /P2 SUR FACE
! FLKS FLUX (VOLUMIQUE) LIQUIDE F_{K,SIGMA}(PWP)
! DFLKS1 DERIVEE DE FLKS/P1
! DFLKS2 DERIVEE DE FLKS/P2
! FTGKS(IFA) FLUX (VOLUMIQUE)GAZ ~F_{K,SIGMA}
! SUR FACE IFA EN NUM DE K
! FTGKS1 DERIVEE DE FTGKS/P1 :
! FTGKS1(MAXFA+1,MAXFA,)
! FTGKS1( 1,IFA ) D_FTGKS(IFA)/DP1K
! FTGKS1(JFA+1,IFA ) D_FTGKS(IFA)/DP1_FACE_JFA_DE_K
! FTGKS2 DERIVEE DE FTGKS/P2
! FCLKS FLUX (VOLUMIQUE)LIQUIDE ^F_{K,SIGMA}(CAD)
! DFCLKS1 DERIVEE DE FCLKS/P1
! DFCLKS2 DERIVEE DE FCLKS/P2
! FTGKS FLUX (VOLUMIQUE)GAZ ~F_{K,SIGMA}(CVP)
! FTGKS1 DERIVEE DE FTGKS/P1 :
! FTGKS2 DERIVEE DE FTGKS/P2
! C MATRICE INTERVENANT DS LE CALCUL DES FLUX FGKS,FLKS
! D MATRICE INTERVENANT DS LE CALCUL DES FLUX FTGKS,FCLKS
! YSS MATRICE INTERVENANT DS LE CALCUL DES MATRICES C ET D
! FLUWS FLUX MASSIQUE EAU TOTAL DANS MAILLE SUSHI
! FLUVPS FLUX MASSIQUE VAPEUR TOTAL DANS MAILLE SUSHI
! FLUASS FLUX MASSIQUE AIR SEC TOTAL DANS MAILLE SUSHI
! FLUADS FLUX MASSIQUE AIR DISSOUS TOTAL DANS MAILLE SUSHI
! FW1S(MAXFA+1) DERIVEE FLUWS / P1_K PUIS P_1,SIGMA
! FW2S(MAXFA+1) DERIVEE FLUWS / P2_K PUIS P_2,SIGMA
! FVP1S(MAXFA+1) DERIVEE FLUVPS / P1_K PUIS P_1,SIGMA
! FVP2S(MAXFA+1) DERIVEE FLUVPS / P2_K PUIS P_2,SIGM
! FAS1S(MAXFA+1) DERIVEE FLUASS / P1_K PUIS P_1,SIGMA
! FAS2S(MAXFA+1) DERIVEE FLUASS / P2_K PUIS P_2,SIGMA
! FAD1S(MAXFA+1) DERIVEE FLUADS / P1_K PUIS P_1,SIGMA
! FAD2S(MAXFA+1) DERIVEE FLUADS / P2_K PUIS P_2,SIGMA
! FMVPS FLUX MASSIQUE VAPEUR INTERVENANT DS EQ DE CONTINUITE
! POUR UNE ARETE EXTERNE
! FMWS FLUX MASSIQUE EAU INTERVENANT DS EQ
! DE CONTINUITE POUR UNE ARETE EXTERNE
! FMASS FLUX MASSIQUE AIR SEC INTERVENANT DS EQ
! DE CONTINUITE POUR UNE ARETE EXTERNE
! FMADS FLUX MASSIQUE AIR DISSOUS INTERVENANT DS EQ
! DE CONTINUITE POUR UNE ARETE EXTERNE
! FM1VPS(MAXFA+1,NFACE) DERIVEE DE FMVPS / P_K PUIS P_1,SIGMA
! FM2VPS(MAXFA+1,NFACE) DERIVEE DE FMVPS / P_K PUIS P_2,SIGMA
! FM1WS(MAXFA+1,NFACE) DERIVEE DE FMWS / P_K PUIS P_1,SIGMA
! FM2WS(MAXFA+1,NFACE) DERIVEE DE FMWS / P_K PUIS P_2,SIGMA
! FM1ASS(MAXFA+1,NFACE) DERIVEE DE FMASS / P_K PUIS P_1,SIGMA
! FM2ASS(MAXFA+1,NFACE) DERIVEE DE FMASS / P_K PUIS P_2,SIGMA
! FM1ADS(MAXFA+1,NFACE) DERIVEE DE FMADS / P_K PUIS P_1,SIGMA
! FM2ADS(MAXFA+1,NFACE) DERIVEE DE FMADS / P_K PUIS P_2,SIGMA
    integer, parameter :: con = 1, dconp1 = 2, dconp2 = 3, diffu  = 4, ddifp1 = 5, ddifp2 = 6
    integer, parameter :: mob = 7, dmobp1 = 8, dmobp2 = 9, masse = 10, dmasp1 = 11, dmasp2 = 12
    integer, parameter :: wliq = 1, wvap = 2, airdis = 3, airsec = 4, eau = 1, air = 2, densit = 14
    integer, parameter :: vkint = 13, kxx = 1, kyy = 2, kzz = 3, kxy = 4, kyz = 5, kzx = 6
    integer, parameter :: rhoga = 1, rholq = 2, rhoga1 = 3, rhoga2 = 4, rholq1 = 5, rholq2 = 6
    integer :: addeme, addep1, addep2, addete, adcome, adcp11, adcp12, adcp21
    integer :: adcp22, adcote
    integer :: ipg, retcom, fa, i, j
    real(kind=8) :: gravity(3), kintvf(6)
    real(kind=8) :: valcen(14, 6), valfac(maxfa, 14, 6)
    aster_logical :: l_matr, l_resi, bool
    real(kind=8) :: dsde(dimcon, dimdef)
    real(kind=8) :: mface(maxfa), dface(maxfa), xface(3, maxfa), normfa(3, maxfa), vol
    integer :: ifa, jfa, idim
    real(kind=8) :: pcp, pwp, pgp, dpgp1, dpgp2, dpwp1, dpwp2
    real(kind=8) :: cvp, dcvp1, dcvp2, cad, dcad1, dcad2
    real(kind=8) :: fluws, fluvps, fluass, fluads
    real(kind=8) :: fw1s(maxfa+1), fw2s(maxfa+1), fvp1s(maxfa+1)
    real(kind=8) :: fas1s(maxfa+1), fas2s(maxfa+1), fvp2s(maxfa+1)
    real(kind=8) :: fad1s(maxfa+1), fad2s(maxfa+1), fmvps(maxfa)
    real(kind=8) :: fmass(maxfa), fmads(maxfa), fmws(maxfa)
    real(kind=8) :: fm1vps(maxfa+1, maxfa), fm2vps(maxfa+1, maxfa)
    real(kind=8) :: fm1ws(maxfa+1, maxfa), fm2ws(maxfa+1, maxfa)
    real(kind=8) :: fm1ass(maxfa+1, maxfa), fm2ass(maxfa+1, maxfa)
    real(kind=8) :: fm1ads(maxfa+1, maxfa), fm2ads(maxfa+1, maxfa)
    real(kind=8) :: pcpf(maxfa), pgpf(maxfa), dpgp1f(maxfa), dpgp2f(maxfa), pwpf(maxfa)
    real(kind=8) :: dpwp1f(maxfa), dpwp2f(maxfa), cvpf(maxfa), dcvp1f(maxfa), cadf(maxfa)
    real(kind=8) :: dcad1f(maxfa), dcad2f(maxfa), dcvp2f(maxfa)
    real(kind=8) :: yss (3, maxfa, maxfa)
    real(kind=8) :: c (maxfa, maxfa), d (maxfa, maxfa)
    real(kind=8) :: flks(maxfa), dflks1(maxfa+1, maxfa), dflks2(maxfa+1, maxfa), fgks(maxfa)
    real(kind=8) :: dfgks1(maxfa+1, maxfa), dfgks2(maxfa+1, maxfa), ftgks(maxfa)
    real(kind=8) :: ftgks1(maxfa+1, maxfa), ftgks2(maxfa+1, maxfa), fclks(maxfa)
    real(kind=8) :: fclks1(maxfa+1, maxfa), fclks2(maxfa+1, maxfa)
    real(kind=8) :: mobwf(maxfa), moadf(maxfa), moasf(maxfa), movpf(maxfa), dw1f(maxfa)
    real(kind=8) :: dw2f(maxfa), dvp1f(maxfa), das1f(maxfa), das2f(maxfa), dad1f(maxfa)
    real(kind=8) :: dvp2f(maxfa), dad2f(maxfa), dvp1ff(maxfa), dvp2ff(maxfa), dw1ffa(maxfa)
    real(kind=8) :: dw2ffa(maxfa), das1ff(maxfa), das2ff(maxfa), dad1ff(maxfa), dad2ff(maxfa)
    real(kind=8) :: divp1(maxfa), divp2(maxfa), diad1(maxfa), diad2(maxfa), dias1(maxfa)
    real(kind=8) :: dias2(maxfa), difuvp(maxfa), difuas(maxfa), difuad(maxfa), diad1f(maxfa)
    real(kind=8) :: diad2f(maxfa), dias1f(maxfa), dias2f(maxfa), divp1f(maxfa), divp2f(maxfa)
    real(kind=8) :: xg(3)
    real(kind=8) :: rhol, rhog, drhol1, drhol2, drhog1, drhog2
    real(kind=8) :: parm_alpha, angl_naut(3)
    real(kind=8), parameter :: zero = 0.d0
    integer :: iadp1k, iadp2k
    integer :: adcm1, adcm2
    integer :: nume_thmc, advico, vicpr1, vicpr2
!
! --------------------------------------------------------------------------------------------------
!
! ADRESSE DANS LA MATRICE DE L ELEMENT CALCULE PAR
! LE VOISIN IVOIS EN LIGNE LIG ET COLONNE COL
! LA CONTRIBUTION PROPRE CORRESPOND AU VOISIN 0
! DES DONNEES DES VOISINS DE LA MAILLE NUMA (0 SI MAILLE PAS ACTIVE)
! ====================================================
#define zzadma(ivois,lig,col) (ivois)*(dimuel)*(dimuel)+(lig-1)*(dimuel)+col
! ===================================================
! FONCTIONS FORMULES D ADRESSAGE DES DDL
! ===================================================
#define iadp1(fa) 2*(fa-1)+1
#define iadp2(fa) 2*(fa-1)+2
#define adcf1(fa) 2*(fa-1)+1
#define adcf2(fa) 2*(fa-1)+2
!
! --------------------------------------------------------------------------------------------------
!
    iadp1k                  = 2*nface+1
    iadp2k                  = 2*nface+2
    adcm1                   = 2*nface+1
    adcm2                   = 2*nface+2
    angl_naut(:)            = zero
    dsde(1:dimcon,1:dimdef) = zero
    pcpf(1:maxfa)   = zero
    pgpf(1:maxfa)   = zero
    dpgp1f(1:maxfa) = zero
    dpgp2f(1:maxfa) = zero
    pwpf(1:maxfa)   = zero
    dpwp1f(1:maxfa) = zero
    dpwp2f(1:maxfa) = zero
    cvpf(1:maxfa)   = zero
    dcvp1f(1:maxfa) = zero
    dcvp2f(1:maxfa) = zero
    cadf(1:maxfa)   = zero
    dcad1f(1:maxfa) = zero
    dcad2f(1:maxfa) = zero
    mobwf(1:maxfa)  = zero
    dw1f(1:maxfa)   = zero
    dw2f(1:maxfa)   = zero
    dw1ffa(1:maxfa) = zero
    dw2ffa(1:maxfa) = zero
    moadf(1:maxfa)  = zero
    dad1f(1:maxfa)  = zero
    dad2f(1:maxfa)  = zero
    dad1ff(1:maxfa) = zero
    dad2ff(1:maxfa) = zero
    moasf(1:maxfa)  = zero
    das1f(1:maxfa)  = zero
    das2f(1:maxfa)  = zero
    das1ff(1:maxfa) = zero
    das2ff(1:maxfa) = zero
    movpf(1:maxfa)  = zero
    dvp1f(1:maxfa)  = zero
    dvp2f(1:maxfa)  = zero
    dvp1ff(1:maxfa) = zero
    dvp2ff(1:maxfa) = zero
    fw1s(1:maxfa+1) =zero
    fw2s(1:maxfa+1) =zero
    fvp1s(1:maxfa+1)=zero
    fvp2s(1:maxfa+1)=zero
    fas1s(1:maxfa+1)=zero
    fas2s(1:maxfa+1)=zero
    fad1s(1:maxfa+1)=zero
    fad2s(1:maxfa+1)=zero
    fluws =zero
    fluvps=zero
    fluass=zero
    fluads=zero
    fmvps(1:maxfa)=zero
    fmws(1:maxfa) =zero
    fmass(1:maxfa)=zero
    fmads(1:maxfa)=zero
    fm1ws(1:maxfa+1,1:maxfa) =zero
    fm2ws(1:maxfa+1,1:maxfa) =zero
    fm1vps(1:maxfa+1,1:maxfa)=zero
    fm2vps(1:maxfa+1,1:maxfa)=zero
    fm1ass(1:maxfa+1,1:maxfa)=zero
    fm2ass(1:maxfa+1,1:maxfa)=zero
    fm1ads(1:maxfa+1,1:maxfa)=zero
    fm2ads(1:maxfa+1,1:maxfa)=zero
!
! - What to compute ?
!
    bool = (option(1:9).eq.'RIGI_MECA' ) .or. (option(1:9).eq.'RAPH_MECA' ) .or.&
           (option(1:9).eq.'FULL_MECA' )
    ASSERT(bool)
    l_resi = ASTER_FALSE
    l_matr = ASTER_FALSE
    if (option(1:9) .eq. 'RIGI_MECA') then
        l_matr = ASTER_TRUE
    else if (option(1:9) .eq. 'RAPH_MECA') then
        l_resi = ASTER_TRUE
    else if (option(1:9) .eq. 'FULL_MECA') then
        l_matr = ASTER_TRUE
        l_resi = ASTER_TRUE
    else
        ASSERT(ASTER_FALSE)
    endif
    if (l_matr) then
        matuu(1:dimuel*dimuel) = zero
    endif
    if (l_resi) then
        vectu(1:dimuel) = zero
    endif
!
! - Initialization of FV quantities
!
    call inices(maxfa, valcen, valfac)
!
! - Parameter for scheme
!
    parm_alpha = carcri(18)
!
! - Get center of cell (last node nno is center ! )
!
    do idim = 1, ndim
        xg(idim) = elem_coor(idim, nno)
    end do
!
! - Get address in generalized stress vector
!
    adcome = mecani(3)
    adcote = tempe(3)
    adcp11 = press1(4)
    adcp12 = press1(5)
    adcp21 = press2(4)
    adcp22 = press2(5)
!
! - Get address in generalized strain vector
!
    addeme = mecani(2)
    addep1 = press1(3)
    addep2 = press2(3)
    addete = tempe(2)
!
! - Get parameters for behaviour
!
    call thmGetBehaviour(compor)
!
! - Get parameters for internal variables
!
    call thmGetBehaviourVari()
!
! - Get storage parameters for behaviours
!
    nume_thmc = ds_thm%ds_behaviour%nume_thmc
    advico    = ds_thm%ds_behaviour%advico
    vicpr1    = ds_thm%ds_behaviour%vicpr1
    vicpr2    = ds_thm%ds_behaviour%vicpr2
!
! - Get initial parameters (THM_INIT)
!
    call thmGetParaInit(j_mater, l_check_ = ASTER_TRUE)
!
! - Compute geometric parameters for current cell
!
    call cabhvf(maxfa    , ndim , nno  , nnos , nface ,&
                elem_coor,&
                vol      , mface, dface, xface, normfa)
!
! - Compute generalized strains
!
    if (ds_thm%ds_elem%l_dof_pre1) then
        defgem(addep1) = dispm(iadp1k)
        defgep(addep1) = dispp(iadp1k)
        do i = 1, ndim
            defgem(addep1+i) = zero
            defgep(addep1+i) = zero
        end do
        if (ds_thm%ds_elem%l_dof_pre2) then
            defgem(addep2) = dispm(iadp2k)
            defgep(addep2) = dispp(iadp2k)
            do i = 1, ndim
                defgem(addep2+i) = zero
                defgep(addep2+i) = zero
            end do
        endif
    endif
!
! - Compute generalized stresses and derivatives
!
    call comthm_vf(option     , j_mater    ,&
                   type_elem  , angl_naut  ,&
                   ndim       , nbvari     ,&
                   dimdef     , dimcon     ,&
                   0          , valfac     , valcen,&
                   adcome     , adcote     , adcp11, adcp12, adcp21, adcp22,&
                   addeme     , addete     , addep1, addep2,&
                   compor     , carcri     ,&
                   defgem     , defgep     ,& 
                   congem     , congep     ,& 
                   vintm(1, 1), vintp(1, 1),& 
                   time_prev  , time_curr  ,&
                   dsde       , gravity    , retcom)
    if (retcom .ne. 0) then
        call utmess('F', 'COMPOR1_9')
    endif
    do fa = 1, nface
        if (ds_thm%ds_elem%l_dof_pre1) then
            defgem(addep1) = dispm(iadp1(fa))
            defgep(addep1) = dispp(iadp1(fa))
            do i = 1, ndim
                defgem(addep1+i) = zero
                defgep(addep1+i) = zero
            end do
            if (ds_thm%ds_elem%l_dof_pre2) then
                defgem(addep2) = dispm(iadp2(fa))
                defgep(addep2) = dispp(iadp2(fa))
                do i = 1, ndim
                    defgem(addep2+i) = zero
                    defgep(addep2+i) = zero
                end do
            endif
        else
            ASSERT(ASTER_FALSE)
        endif
        do i = 1, dimcon
            do j = 1, dimdef
                dsde(i,j) = zero
            end do
        end do
! ----- Compute generalized stresses and derivatives
        call comthm_vf(option        , j_mater       ,&
                       type_elem     , angl_naut     ,&
                       ndim          , nbvari        ,&
                       dimdef        , dimcon        ,&
                       fa            , valfac        , valcen,&
                       adcome        , adcote        , adcp11, adcp12, adcp21, adcp22,&
                       addeme        , addete        , addep1, addep2,&
                       compor        , carcri        ,&
                       defgem        , defgep        ,& 
                       congem        , congep        ,& 
                       vintm(1, fa+1), vintp(1, fa+1),& 
                       time_prev     , time_curr     ,&
                       dsde          , gravity       , retcom)
        if (retcom .ne. 0) then
            call utmess('F', 'COMPOR1_9')
        endif
    end do
!
! - Set 
!
    if (l_resi) then
        vectu(adcm1) = valcen(masse, eau)*vol
        vectu(adcm2) = valcen(masse, air)*vol
    endif
    if (l_matr) then
        matuu(zzadma(0,adcm1,iadp1k)) = valcen(dmasp1, eau)*vol
        matuu(zzadma(0,adcm2,iadp1k)) = valcen(dmasp1, air)*vol
        matuu(zzadma(0,adcm1,iadp2k)) = valcen(dmasp2, eau)*vol
        matuu(zzadma(0,adcm2,iadp2k)) = valcen(dmasp2, air)*vol
    endif
    rhol   = valcen(densit ,rholq)
    drhol1 = valcen(densit ,rholq1)
    drhol2 = valcen(densit ,rholq2)
    rhog   = valcen(densit ,rhoga)
    drhog1 = valcen(densit ,rhoga1)
    drhog2 = valcen(densit ,rhoga2)
    if (ndim .eq. 2) then
        kintvf(1) = valcen(vkint ,kxx)
        kintvf(2) = valcen(vkint ,kyy)
        kintvf(3) = valcen(vkint ,kxy)
        kintvf(4) = zero
        kintvf(5) = zero
        kintvf(6) = zero
    else
        kintvf(1) = valcen(vkint ,kxx)
        kintvf(2) = valcen(vkint ,kyy)
        kintvf(3) = valcen(vkint ,kzz)
        kintvf(4) = valcen(vkint ,kxy)
        kintvf(5) = valcen(vkint ,kyz)
        kintvf(6) = valcen(vkint ,kzx)
    endif
!
! - Compute what ?
!
    call cacdsu(maxfa    , parm_alpha,&
                ndim     , nno       , nface ,&
                elem_coor,&
                vol      , mface     , dface ,&
                xface    , normfa    , kintvf,&
                yss      , c         , d    )
!
! - Get pressures and derivatives
!
    pcp = dispp(iadp1k)
    pgp = dispp(iadp2k)
    dpgp1 = zero
    dpgp2 = 1.d0
    do ifa = 1, nface
        pcpf(ifa) = dispp(iadp1(ifa))
        pgpf(ifa) = dispp(iadp2(ifa))
        dpgp1f(ifa) = zero
        dpgp2f(ifa) = 1.d0
    end do
    pwp = pgp-pcp
    dpwp1 = -1.d0
    dpwp2 = +1.d0
    do ifa = 1, nface
        pwpf(ifa) = pgpf(ifa)-pcpf(ifa)
        dpwp1f(ifa) = -1.d0
        dpwp2f(ifa) = 1.d0
    end do
    cvp = valcen(con,wvap)
    dcvp1 = valcen(dconp1,wvap)
    dcvp2 = valcen(dconp2,wvap)
    do ifa = 1, nface
        cvpf (ifa) = valfac(ifa,con,wvap)
        dcvp1f(ifa) = valfac(ifa,dconp1,wvap)
        dcvp2f(ifa) = valfac(ifa,dconp2,wvap)
    end do
    cad = valcen(con,airdis)
    dcad1 = valcen(dconp1,airdis)
    dcad2 = valcen(dconp2,airdis)
    do ifa = 1, nface
        cadf(ifa) = valfac(ifa,con,airdis)
        dcad1f(ifa) = valfac(ifa,dconp1,airdis)
        dcad2f(ifa) = valfac(ifa,dconp2,airdis)
    end do
!
! - Save pressures in internal variables
!
    if (nume_thmc .eq. LIQU_AD_GAZ) then
        do ipg = 1, nface+1
            vintp(advico+vicpr1,ipg) = pcp
            vintp(advico+vicpr2,ipg) = pgp
        end do
    endif
!
! - Compute "volumic" flux
!
    call vfcfks(l_matr, maxfa  , ndim  , nface,&
                cvp   , dcvp1  , dcvp2 ,&
                cvpf  , dcvp1f , dcvp2f,&
                d     , gravity,&
                zero  , zero   , zero  ,&
                xg    , xface  ,&
                ftgks , ftgks1  , ftgks2)
    call vfcfks(l_matr, maxfa  , ndim  , nface,&
                cad   , dcad1  , dcad2 ,&
                cadf  , dcad1f , dcad2f,&
                d     , gravity,&
                zero  , zero   , zero  ,&
                xg    , xface  ,&
                fclks , fclks1 , fclks2)
    call vfcfks(l_matr, maxfa  , ndim  , nface,&
                pwp   , dpwp1  , dpwp2 ,&
                pwpf  , dpwp1f , dpwp2f,&
                c     , gravity,&
                rhol  , drhol1 , drhol2,&
                xg    , xface  ,&
                flks  , dflks1 , dflks2)
    call vfcfks(l_matr, maxfa  , ndim  , nface,&
                pgp   , dpgp1  , dpgp2 ,&
                pgpf  , dpgp1f , dpgp2f,&
                c     , gravity,&
                rhog  , drhog1 , drhog2,&
                xg    , xface  ,&
                fgks  , dfgks1 , dfgks2)
!
! - Get diffusion
!
    do ifa = 1, nface
        difuvp(ifa) = valcen(diffu,wvap)
        difuas(ifa) = -valcen(diffu,airsec)
        difuad(ifa) = valcen(diffu,airdis)
        divp1(ifa)  = valcen(ddifp1,wvap)
        divp2(ifa)  = valcen(ddifp2,wvap)
        divp1f(ifa) = zero
        divp2f(ifa) = zero
        dias1(ifa)  = -valcen(ddifp1,airsec)
        dias2(ifa)  = -valcen(ddifp2,airsec)
        dias1f(ifa) = zero
        dias2f(ifa) = zero
        diad1(ifa)  = valcen(ddifp1,airdis)
        diad2(ifa)  = valcen(ddifp2,airdis)
        diad1f(ifa) = zero
        diad2f(ifa) = zero
    end do
!
! - Get mobility
!
    do ifa = 1, nface
        if (flks(ifa) .ge. zero) then
            mobwf(ifa)  = valcen(mob,wliq)
            dw1f(ifa)   = valcen(dmobp1,wliq)
            dw2f(ifa)   = valcen(dmobp2,wliq)
            dw1ffa(ifa) = zero
            dw2ffa(ifa) = zero
            moadf(ifa)  = valcen(mob,airdis)
            dad1f(ifa)  = valcen(dmobp1,airdis)
            dad2f(ifa)  = valcen(dmobp2,airdis)
            dad1ff(ifa) = zero
            dad2ff(ifa) = zero
        else
            mobwf(ifa)  = valfac(ifa,mob,wliq)
            dw1f(ifa)   = zero
            dw2f(ifa)   = zero
            dw1ffa(ifa) = valfac(ifa,dmobp1,wliq)
            dw2ffa(ifa) = valfac(ifa,dmobp2,wliq)
            moadf(ifa)  = valfac(ifa,mob,airdis)
            dad1f(ifa)  = zero
            dad2f(ifa)  = zero
            dad1ff(ifa) = valfac(ifa,dmobp1,airdis)
            dad2ff(ifa) = valfac(ifa,dmobp2,airdis)
        endif
        if (fgks(ifa) .ge. zero) then
            moasf(ifa)  = valcen(mob,airsec)
            das1f(ifa)  = valcen(dmobp1,airsec)
            das2f(ifa)  = valcen(dmobp2,airsec)
            das1ff(ifa) = zero
            das2ff(ifa) = zero
            movpf(ifa)  = valcen(mob,wvap)
            dvp1f(ifa)  = valcen(dmobp1,wvap)
            dvp2f(ifa)  = valcen(dmobp2,wvap)
            dvp1ff(ifa) = zero
            dvp2ff(ifa) = zero
        else
            moasf(ifa)  = valfac(ifa,mob,airsec)
            das1f(ifa)  = zero
            das2f(ifa)  = zero
            das1ff(ifa) = valfac(ifa,dmobp1,airsec)
            das2ff(ifa) = valfac(ifa,dmobp2,airsec)
            movpf(ifa)  = valfac(ifa,mob,wvap)
            dvp1f(ifa)  = zero
            dvp2f(ifa)  = zero
            dvp1ff(ifa) = valfac(ifa,dmobp1,wvap)
            dvp2ff(ifa) = valfac(ifa,dmobp2,wvap)
        endif
    end do
!
! - Compute "massic" flux
!
    do ifa = 1, nface
        call cafmes(ifa       , ASTER_TRUE, l_matr, maxfa, nface,&
                    flks(ifa) , dflks1    , dflks2,&
                    mobwf(ifa), dw1f      , dw2f  ,&
                    dw1ffa    , dw2ffa    ,&
                    fmws      , fm1ws     , fm2ws)
        call cafmes(ifa       , ASTER_TRUE, l_matr, maxfa, nface,&
                    fgks(ifa) , dfgks1    , dfgks2,&
                    movpf(ifa), dvp1f     , dvp2f ,&
                    dvp1ff    , dvp2ff    ,&
                    fmvps     , fm1vps    , fm2vps)
        call cafmes(ifa        , l_resi, l_matr, maxfa, nface,&
                    ftgks(ifa) , ftgks1, ftgks2,&
                    difuvp(ifa), divp1 , divp2 ,&
                    divp1f     , divp2f,&
                    fmvps      , fm1vps, fm2vps)
        call cafmes(ifa       , ASTER_TRUE, l_matr, maxfa, nface,&
                    fgks(ifa) , dfgks1    , dfgks2,&
                    moasf(ifa), das1f     , das2f ,&
                    das1ff    , das2ff    ,&
                    fmass     , fm1ass    , fm2ass)
        call cafmes(ifa        , l_resi, l_matr, maxfa, nface,&
                    ftgks(ifa) , ftgks1, ftgks2,&
                    difuas(ifa), dias1 , dias2 ,&
                    dias1f     , dias2f,&
                    fmass      , fm1ass, fm2ass)
        call cafmes(ifa       , ASTER_TRUE, l_matr, maxfa, nface,&
                    flks(ifa) , dflks1    , dflks2,&
                    moadf(ifa), dad1f     , dad2f ,&
                    dad1ff    , dad2ff    ,&
                    fmads     , fm1ads    , fm2ads)
        call cafmes(ifa        , l_resi, l_matr, maxfa, nface,&
                    fclks(ifa) , fclks1, fclks2,&
                    difuad(ifa), diad1 , diad2 ,&
                    diad1f     , diad2f,&
                    fmads      , fm1ads, fm2ads)
    end do
!
! - Compute total "volumic" flux
!
    call cafves(l_matr, maxfa , nface ,&
                flks  , dflks1, dflks2,&
                mobwf , dw1f  , dw2f  ,&
                dw1ffa, dw2ffa,&
                fluws , fw1s  , fw2s)
    call cafves(l_matr, maxfa , nface ,&
                fgks  , dfgks1, dfgks2,&
                movpf , dvp1f , dvp2f ,&
                dvp1ff, dvp2ff,&
                fluvps, fvp1s, fvp2s)
    call cafves(l_matr, maxfa , nface ,&
                ftgks , ftgks1, ftgks2,&
                difuvp, divp1 , divp2 ,&
                divp1f, divp2f,&
                fluvps, fvp1s , fvp2s)
    call cafves(l_matr, maxfa , nface ,&
                fgks  , dfgks1, dfgks2,&
                moasf , das1f , das2f ,&
                das1ff, das2ff,&
                fluass, fas1s , fas2s)
    call cafves(l_matr, maxfa, nface,&
                ftgks, ftgks1, ftgks2,&
                difuas, dias1, dias2,&
                dias1f, dias2f,&
                fluass, fas1s, fas2s)
    call cafves(l_matr, maxfa , nface ,&
                flks  , dflks1, dflks2,&
                moadf , dad1f , dad2f ,&
                dad1ff, dad2ff,&
                fluads, fad1s , fad2s)
    call cafves(l_matr, maxfa , nface ,&
                fclks , fclks1, fclks2,&
                difuad, diad1 , diad2 ,&
                diad1f, diad2f,&
                fluads, fad1s , fad2s)
!
! - Compute residual
!
    if (l_resi) then
! ----- Continuity of flux
        do ifa = 1, nface
            congep(adcp11+1,ifa+1) = fmws(ifa)+fmvps(ifa)
            congep(adcp12+1,ifa+1) = fmass(ifa)+fmads(ifa)
            vectu(adcf1(ifa))      = congep(adcp11+1,ifa+1)
            vectu(adcf2(ifa))      = congep(adcp12+1,ifa+1)
        end do
! ----- Conservation of mass
        congep(adcp11+1,1) = fluws
        congep(adcp12+1,1) = fluvps
        congep(adcp21+1,1) = fluass
        congep(adcp22+1,1) = fluads
        vectu(adcm1)       = vectu(adcm1)+congep(adcp11+1,1) + congep(adcp12+1,1)
        vectu(adcm2)       = vectu(adcm2)+congep(adcp21+1,1) + congep(adcp22+1,1)
    endif
!
! - Compute matrix
!
    if (l_matr) then
        matuu(zzadma(0,adcm1,iadp1k))= matuu(zzadma(0,adcm1,iadp1k))+fw1s(1)+fvp1s(1)
        matuu(zzadma(0,adcm1,iadp2k))= matuu(zzadma(0,adcm1,iadp2k))+fw2s(1)+fvp2s(1)
        matuu(zzadma(0,adcm2,iadp1k))= matuu(zzadma(0,adcm2,iadp1k))+fas1s(1)+fad1s(1)
        matuu(zzadma(0,adcm2,iadp2k))= matuu(zzadma(0,adcm2,iadp2k))+fas2s(1)+fad2s(1)
        do ifa = 1, nface
            matuu(zzadma(0,adcm1,iadp1(ifa)))= matuu(zzadma(0,adcm1,iadp1(ifa))) +&
                fw1s(ifa+1)+fvp1s(ifa+1)
            matuu(zzadma(0,adcm1,iadp2(ifa)))= matuu(zzadma(0,adcm1,iadp2(ifa))) +&
                fw2s(ifa+1)+fvp2s(ifa+1)
            matuu(zzadma(0,adcm2,iadp1(ifa)))= matuu(zzadma(0,adcm2,iadp1(ifa))) +&
                fas1s(ifa+1)+fad1s(ifa+1)
            matuu(zzadma(0,adcm2,iadp2(ifa)))= matuu(zzadma(0,adcm2,iadp2(ifa))) +&
                fas2s(ifa+1)+fad2s(ifa+1)
            matuu(zzadma(0,adcf1(ifa),iadp1k))= matuu(zzadma(0,adcf1(ifa),iadp1k)) +&
                fm1ws(1,ifa)+fm1vps(1,ifa)
            matuu(zzadma(0,adcf1(ifa),iadp2k))= matuu(zzadma(0,adcf1(ifa),iadp2k)) +&
                fm2ws(1,ifa)+fm2vps(1,ifa)
            matuu(zzadma(0,adcf2(ifa),iadp1k))= matuu(zzadma(0,adcf2(ifa),iadp1k)) +&
                fm1ass(1,ifa)+fm1ads(1,ifa)
            matuu(zzadma(0,adcf2(ifa),iadp2k))= matuu(zzadma(0,adcf2(ifa),iadp2k)) +&
                fm2ass(1,ifa)+fm2ads(1,ifa)
            do jfa = 1, nface
                matuu(zzadma(0,adcf1(ifa),iadp1(jfa)))= matuu(zzadma(0,adcf1(ifa),iadp1(jfa))) +&
                    fm1ws(jfa+1,ifa)+fm1vps(jfa+1,ifa)
                matuu(zzadma(0,adcf1(ifa),iadp2(jfa)))= matuu(zzadma(0,adcf1(ifa),iadp2(jfa))) +&
                    fm2ws(jfa+1,ifa)+fm2vps(jfa+1,ifa)
                matuu(zzadma(0,adcf2(ifa),iadp1(jfa)))= matuu(zzadma(0,adcf2(ifa),iadp1(jfa))) +&
                    fm1ass(jfa+1,ifa)+fm1ads(jfa+1,ifa)
                matuu(zzadma(0,adcf2(ifa),iadp2(jfa)))= matuu(zzadma(0,adcf2(ifa),iadp2(jfa))) +&
                    fm2ass(jfa+1,ifa)+fm2ads(jfa+1,ifa)
            end do
        end do
    endif
end subroutine
