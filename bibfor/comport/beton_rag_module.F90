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

module beton_rag_module
    use tenseur_meca_module
    implicit None
!
! person_in_charge: jean-luc.flejou at edf.fr
!
#include "asterf_types.h"
!
    type :: beton_rag_mat_fluage
        real(kind=8) :: k1,k2,n1,n2
    end type beton_rag_mat_fluage

    type :: beton_rag_mat_pw
        ! Coefficients Van Genuchten
        real(kind=8) :: a,b,bw
    end type beton_rag_mat_pw

    type :: beton_rag_mat_gel
    ! Avancement du gel
        ! Cinétique d'avancement identifiée à Tref
        real(kind=8) :: alpha0, tref
        ! Énergie d'activation / Constante gaz parfait
        real(kind=8) :: ear
        ! Seuil de saturation
        real(kind=8) :: sr0
    ! Pression du gel
        ! Volume de gel maximum pouvant être créé
        real(kind=8) :: vg
        ! Module d'élasticité du gel
        real(kind=8) :: mg
        ! Coefficient de "biot" du gel
        real(kind=8) :: bg
        ! Seuil de comblement de la porosité connectée
        real(kind=8) :: a0
        ! RAG : Déformation visqueuse
        real(kind=8) :: epsi0
    end type beton_rag_mat_gel

    type :: beton_rag_materiau
        ! Mécanique
        real(kind=8) :: young, nu, alpha, bendo
        real(kind=8) :: mc, siguc
        real(kind=8) :: mt, sigut
        real(kind=8) :: dhom
        ! Fluage
        type(beton_rag_mat_fluage) :: fluage_sph
        type(beton_rag_mat_fluage) :: fluage_dev
        ! Avancement avancement gel
        type(beton_rag_mat_gel) :: gel
        ! Pression d'eau capillaire
        type(beton_rag_mat_pw) :: pw
    end type beton_rag_materiau

    type :: beton_rag_parametres
        ! les instants
        real(kind=8)  ::  instap
        real(kind=8)  ::  instam
        real(kind=8)  ::  dtemps
        ! les températures
        real(kind=8)  ::  temperp   = 0.0
        real(kind=8)  ::  temperm   = 0.0
        real(kind=8)  ::  temperref = 0.0
        real(kind=8)  ::  dtemper   = 0.0
        aster_logical ::  istemper  = .false.
        ! les hydratations
        real(kind=8)  ::  hydratp   = 0.0
        real(kind=8)  ::  hydratm   = 0.0
        real(kind=8)  ::  dhydrat   = 0.0
        aster_logical ::  ishydrat  = .false.
        ! les séchages
        real(kind=8)  ::  sechagp   = 0.0
        real(kind=8)  ::  sechagm   = 0.0
        real(kind=8)  ::  sechagref = 0.0
        real(kind=8)  ::  dsechag   = 0.0
        aster_logical ::  issechag = .false.
        ! Nombre d'itérations maxi (ITER_INTE_MAXI)
        real(kind=8) ::  nbdecp
        ! Tolérance de convergence (RESI_INTE_RELA)
        real(kind=8) ::  errmax
        ! Loi à intégrer
        !   1 : Mécanique seule
        !   2 : Mécanique + Fluage
        integer      :: loi_integre = 0
        ! Calcul fait par perturbation ou pas
        logical      :: perturbation = .false.
        ! Calcul de fluage
        logical      :: fluage       = .false.
        ! Calcul des grandeurs à + ou pas
        logical      :: resi         = .false.
        ! calcul de la matrice de raideur tangente
        logical      :: rigi         = .false.
    end type beton_rag_parametres

    type,private :: beton_rag_pression
        ! Pression du gel
        real(kind=8) :: Pgel = 0.0
        ! Pression capillaire
        real(kind=8) :: Pcap = 0.0
        ! Déformation visqueuse due à la RAG
        real(kind=8) :: EpsiVRAG(6) = 0.0
    end type beton_rag_pression


    private :: BR_rk5app, BR_rk5adp, BR_Mecanique, BR_Mecanique_Fluage
    private :: beton_rag_raideur, beton_rag_mecanique_fluage, beton_rag_grd, pow

    integer, parameter, private :: BR_VARI_SEUIL_ENDOMMAGEMENT  =  1
    integer, parameter, private :: BR_VARI_EPSI_FLUAGE          =  8
    integer, parameter, private :: BR_VARI_EPSI_FLUAGE_INTERNE  = 15
    integer, parameter, private :: BR_VARI_AVANCEMENT_CHIMIQUE  = 22
    integer, parameter, private :: BR_VARI_RAG_ENDOMMAGEMENT    = 23
    integer, parameter, private :: BR_VARI_EPSI_VISC_RAG        = 26
    integer, parameter, private :: BR_VARI_PRESSION_GEL         = 32
    !
    integer, parameter          :: BR_VARI_LOI_INTEGRE          = 33
    integer, parameter          :: BR_VARI_NOMBRE               = 33

contains

    ! ------------------------------------------------------------------------------------------
    ! Tenseur(ordre=4) BetonRag
    type(tenseur4) function beton_rag_raideur(young,nu,UnMoinsD) result(X)
        real(kind=8), intent(in) :: young,nu
        type(vecteur), optional, intent(in) :: UnMoinsD
        !
        real(kind=8) :: Anu, b1,b2,b3
        !
        if ( present(UnMoinsD) ) then
            b1 = UnMoinsD%vect(1)
            b2 = UnMoinsD%vect(2)
            b3 = UnMoinsD%vect(3)
        else
            b1 = 1.0D0
            b2 = 1.0D0
            b3 = 1.0D0
        endif
        !
        Anu = b1*b2*b3 - nu*nu*(b1+b2+b3) - 2.0*nu*nu*nu
        !
        X%tens(1,1,1,1) = (b2*b3-nu*nu)/Anu
        X%tens(1,1,2,2) = nu*(nu+b3)/Anu
        X%tens(1,1,3,3) = nu*(nu+b2)/Anu
        X%tens(2,2,1,1) = nu*(nu+b3)/Anu
        X%tens(2,2,2,2) = (b1*b3-nu*nu)/Anu
        X%tens(2,2,3,3) = nu*(nu+b1)/Anu
        X%tens(3,3,1,1) = nu*(nu+b2)/Anu
        X%tens(3,3,2,2) = nu*(nu+b1)/Anu
        X%tens(3,3,3,3) = (b1*b2-nu*nu)/Anu
        X%tens(1,2,1,2) = 1.0/(b1*b2*(1.0+nu))
        X%tens(1,3,1,3) = 1.0/(b1*b3*(1.0+nu))
        X%tens(2,3,2,3) = 1.0/(b2*b3*(1.0+nu))
        X%tens(2,1,2,1) = 1.0/(b1*b2*(1.0+nu))
        X%tens(3,1,3,1) = 1.0/(b1*b3*(1.0+nu))
        X%tens(3,2,3,2) = 1.0/(b2*b3*(1.0+nu))
        !
        X%tens = X%tens*young
    end function beton_rag_raideur


    type(beton_rag_pression) function beton_rag_grd(epsm, mater_br, Avc, Sr) result(X)
        implicit none
        !
        real(kind=8),               intent(in) :: epsm(6), Avc, Sr
        type(beton_rag_materiau),   intent(in) :: mater_br
        !
        ! ------------------------------------------------------------------------------------------
        !
        real(kind=8) :: vaux1
        !
        ! ------------------------------------------------------------------------------------------
        !
        ! Calcul de la pression du gel
        vaux1 = epsm(1) + epsm(2) + epsm(3)
        vaux1 = max( 0.0 , mater_br%gel%a0*mater_br%gel%vg + mater_br%gel%bg*vaux1 )
        vaux1 = max( 0.0 , Avc*mater_br%gel%vg - vaux1)
        X%Pgel = mater_br%gel%mg*vaux1
        ! Calcul de la pression capillaire !! Elle est <=0.
        if      ( Sr >= 0.9999  ) then
            X%Pcap = 0.0d0
        else if ( Sr >= 0.1000 ) then
            X%Pcap = -mater_br%pw%a*Sr*pow(pow(Sr,-mater_br%pw%b) -1.0, 1.0-1.0/mater_br%pw%b)
        endif
    end function beton_rag_grd

    real(kind=8) function pow(xx,puiss)  result(X)
        implicit none
        real(kind=8),intent(in)  :: xx, puiss
        !
        if (log10(xx)*puiss .gt. 200.0) then
            X = 1.0
        else
            X = xx**puiss
        endif
    end function pow


    subroutine ldc_beton_rag(epsm, deps, sigm, vim, mater_br, param_br, &
                                        sigp, vip, dsidep, iret)
        implicit none
        !
#include "asterfort/assert.h"
        !
        real(kind=8),               intent(in) :: epsm(6), deps(6), sigm(6), vim(*)
        type(beton_rag_materiau),   intent(in) :: mater_br
        type(beton_rag_parametres), intent(in) :: param_br
        integer, intent(inout)                 :: iret
        !
        real(kind=8), intent(out) :: sigp(6)
        real(kind=8), intent(out) :: vip(*)
        real(kind=8), intent(out) :: dsidep(6, 6)
        !
        ! ------------------------------------------------------------------------------------------
        !
        real(kind=8) :: epsmeca(6)=0.0d0, epsflua(6)=0.0d0, epsanel(6)=0.0d0, epsvrag(6)=0.0d0
        type(beton_rag_pression) :: grandeur_press
        !
        ! ------------------------------------------------------------------------------------------
        !
        iret = 0
        if      ( param_br%loi_integre == 1 ) then
            ! Déformations : Thermique, Hydratation
            if ( param_br%istemper ) then
                epsanel(1:3) = -mater_br%alpha*(param_br%temperp - param_br%temperref)
            endif
            if ( param_br%ishydrat ) then
                epsanel(1:3) = epsanel(1:3) + mater_br%bendo*param_br%hydratp
            endif
            ! Déformations de fluage
            epsflua = VecteurDeviaSpher( vim(BR_VARI_EPSI_FLUAGE:BR_VARI_EPSI_FLUAGE+5) , &
                                         vim(BR_VARI_EPSI_FLUAGE+6) )
            ! Déformation visqueuse de la RAG
            epsvrag = vim(BR_VARI_EPSI_VISC_RAG:BR_VARI_EPSI_VISC_RAG+5)
            ! Pression du gel et pression capillaire
            grandeur_press = beton_rag_grd(epsm, mater_br, vim(BR_VARI_AVANCEMENT_CHIMIQUE), &
                                           param_br%sechagp)
            ! Déformation mécanique
            epsmeca = epsm + epsanel - epsflua - epsvrag
            call BR_Mecanique(epsmeca, deps, vim, mater_br, param_br, grandeur_press, &
                              sigp, vip, dsidep )
        else if ( (param_br%loi_integre == 2) .or. &
                  (param_br%loi_integre == 3) ) then
            call BR_Mecanique_Fluage(epsm, deps, vim, mater_br, param_br, &
                                     sigp, vip, dsidep, iret)
        else
            ASSERT( .FALSE. )
        endif
    end subroutine ldc_beton_rag


    subroutine BR_Mecanique(epsm, deps, vim, mater_br, param_br, grd_press, &
                            sigp, vip, dsidep )
        implicit none
        !
        real(kind=8),               intent(in)    :: epsm(6), deps(6), vim(*)
        type(beton_rag_materiau),   intent(in)    :: mater_br
        type(beton_rag_parametres), intent(in)    :: param_br
        type(beton_rag_pression),   intent(inout) :: grd_press
        !
        real(kind=8), intent(out) :: sigp(6)
        real(kind=8), intent(out) :: vip(*)
        real(kind=8), intent(out) :: dsidep(6, 6)
        !
        ! ------------------------------------------------------------------------------------------
        !
        type(tenseur4)   :: KElas0, KElasD
        type(tenseur2)   :: TSigma , TEpsi, SigmaRB, SigmaR, SigmaTracD, SigmaCompD
        type(tenseur2)   :: EpsiTrac, EpsiComp, EpsiTracRP,  SigmaTracDRP
        type(vecteur)    :: UnMoinsDt
        type(basepropre) :: SigmaB, SigmaRP
        type(TracComp)   :: SigmaTC
        type(tenseur2)   :: TEpsiVRAG
        !
        real(kind=8)     :: nu, young, sigut, mt, siguc, mc, delthom, NormSigm
        real(kind=8)     :: b1, b2, b3, sigceq, sigdp, UnMoinsDc
        real(kind=8)     :: Dommage_Rag(3), bgel, EpsiVRAG(6)
        real(kind=8)     :: xx1,xx2,xx3
        !
        logical          :: perturb, fluage, isendomtrac, isendomcomp
        ! ------------------------------------------------------------------------------------------
        !
        young   = abs(mater_br%young)
        nu      = abs(mater_br%nu)
        sigut   = abs(mater_br%sigut)
        mt      = abs(mater_br%mt)
        siguc   = abs(mater_br%siguc)
        mc      = abs(mater_br%mc)
        delthom = abs(mater_br%dhom)
        !
        isendomtrac = ( mater_br%sigut > 0.0 )
        isendomcomp = ( mater_br%siguc > 0.0 )
        !
        perturb  = param_br%perturbation
        fluage   = param_br%fluage
        NormSigm = 10.0**(nint(log10(siguc) - 3))
        !
        ! Variables internes pour la mécanique
        SigmaR              = vim(BR_VARI_SEUIL_ENDOMMAGEMENT:BR_VARI_SEUIL_ENDOMMAGEMENT+5)
        sigdp               = vim(BR_VARI_SEUIL_ENDOMMAGEMENT+6)
        ! Endommagement de RAG : d/(1-d)
        Dommage_Rag(1:3)    = vim(BR_VARI_RAG_ENDOMMAGEMENT:BR_VARI_RAG_ENDOMMAGEMENT+2)
        EpsiVRAG(1:6)       = vim(BR_VARI_EPSI_VISC_RAG:BR_VARI_EPSI_VISC_RAG+5)
        !
        KElas0 = beton_rag_raideur(young,nu)
        ! Tenseur des déformations
        TEpsi  = epsm + deps
        ! Tenseur des contraintes effectives, base initiale
        TSigma = ContractT4T2(KElas0 , TEpsi)
        ! SigmaB : tenseur propre, base propre, ...
        SigmaB = basevecteurpropre( TSigma, NormSigm )
        !
        ! Sigma de traction et de compression, base initiale
        SigmaTC = TractionCompression(SigmaB)
        ! Déformation de traction et de compression, base initiale
        EpsiTrac = ((1.0d0+nu)*SigmaTC%traction - nu*trace(SigmaTC%traction)*Identite())/young
        EpsiComp = ((1.0d0+nu)*SigmaTC%compress - nu*trace(SigmaTC%compress)*Identite())/young
        !
        ! ---------------------------------------------------------------- Traction
        if ( SigmaTC%istraction ) then
            ! SigmaRB : Passage de SigmaR dans la base propre des contraintes
            if ( .not. perturb ) then
                SigmaRB = VersBasePrope(SigmaB,SigmaR)
                ! Le sup
                SigmaRB%tens(1,1)= max(SigmaRB%tens(1,1), SigmaTC%valept%vect(1))
                SigmaRB%tens(2,2)= max(SigmaRB%tens(2,2), SigmaTC%valept%vect(2))
                SigmaRB%tens(3,3)= max(SigmaRB%tens(3,3), SigmaTC%valept%vect(3))
                ! Passage de SigmaRB dans la base initiale des contraintes
                SigmaR = VersBaseInitiale(SigmaB,SigmaRB)
            endif
            ! SigmaRP : tenseur propre et base propre du tenseur d'endommagement
            SigmaRP = basevecteurpropre( SigmaR, NormSigm )
            ! Calcul des bi. On se protège des VP légèrement négatives, numériquement possible
            xx1 = (max( 0.0, SigmaRP%valep%vect(1)/sigut )**mt)/mt
            xx2 = (max( 0.0, SigmaRP%valep%vect(2)/sigut )**mt)/mt
            xx3 = (max( 0.0, SigmaRP%valep%vect(3)/sigut )**mt)/mt
            ! On protège contre un argument trop grand, on limite donc l'endommagement.
            ! Avec 10 c'est d <= 0.999955
            b1 = exp( min(10.0,xx1) ); b2 = exp( min(10.0,xx2) ); b3 = exp( min(10.0,xx3) )
            if ( isendomtrac ) then
                UnMoinsDt = [b1,b2,b3]
            else
                UnMoinsDt = [1.0d0,1.0d0,1.0d0]
            endif
            ! Dans le cas d'un calcul avec RAG
            if ( param_br%loi_integre == 3 ) then
                xx1  = (max( 0.0, mater_br%gel%bg*grd_press%Pgel/sigut )**mt)/mt
                bgel = exp( min(10.0,xx1) )
                Dommage_Rag(1) = max( Dommage_Rag(1) , min(b1,bgel) - 1.0 )
                Dommage_Rag(2) = max( Dommage_Rag(2) , min(b2,bgel) - 1.0 )
                Dommage_Rag(3) = max( Dommage_Rag(3) , min(b3,bgel) - 1.0 )
                TEpsiVRAG      = [ Dommage_Rag(1) , Dommage_Rag(2), Dommage_Rag(3) ]
                ! Passage de TEpsiVRAGloc dans le repère initial des contraintes
                TEpsiVRAG = VersBaseInitiale(SigmaRP,TEpsiVRAG)
                EpsiVRAG  = mater_br%gel%epsi0*TenseurVecteur( TEpsiVRAG )
            endif
            ! Tenseur élastique endommagé
            KElasD = beton_rag_raideur(young,nu,UnMoinsDt)
            ! EpsiTracRP : EpsiTrac dans la base des endommagements
            EpsiTracRP   = VersBasePrope(SigmaRP, EpsiTrac)
            SigmaTracDRP = ContractT4T2(KElasD, EpsiTracRP)
            ! SigmaTracD : Contrainte de traction, base initiale
            SigmaTracD  = VersBaseInitiale(SigmaRP,SigmaTracDRP)
        else
            SigmaTracD = 0.0d0
        endif
        !
        ! ---------------------------------------------------------------- Compression
        if ( SigmaTC%iscompress ) then
            ! Calcul des invariants de Compression : SigmaB%valepc%vect(i) < 0
            if ( .not. perturb ) then
                sigceq = sqrt(Invariant2(SigmaTC%valepc)) + delthom*Invariant1(SigmaTC%valepc)/3.0d0
                sigdp  = max(sigdp, max(0.0d0,sigceq))
            endif
            if ( isendomcomp ) then
                xx1 = -((sigdp/siguc)**mc)/mc
                UnMoinsDc = exp( max( -10.0, xx1 ) )
            else
                UnMoinsDc = 1.0d0
            endif
            ! SigmaCompD : Contrainte de compression
            SigmaCompD = UnMoinsDc*ContractT4T2(KElas0,EpsiComp)
        else
            SigmaCompD = 0.0d0
            if ( isendomcomp ) then
                xx1 = -((sigdp/siguc)**mc)/mc
                UnMoinsDc = exp( max(-10.0, xx1) )
            else
                UnMoinsDc = 1.0d0
            endif
        endif
        !
        ! ---------------------------------------------------------------- Traction + Compression
        TSigma   = SigmaCompD + UnMoinsDc*SigmaTracD
        !
        ! On met à jour à t+, si :
        !   on ne fait pas de calcul par perturbation
        !   on ne fait pas de calcul de fluage
        if (.not. perturb .and. .not. fluage ) then
            if ( param_br%rigi ) then
                dsidep = KElas0
            endif
            ! On met à jour les variables à t+
            if ( param_br%resi ) then
                sigp = TenseurVecteurAster( TSigma )
                ! Ajout de la pression du gel et pression capillaire
                sigp(1:3) = sigp(1:3) + grd_press%Pgel + grd_press%Pcap
                ! Variables internes pour la mécanique
                vip(BR_VARI_SEUIL_ENDOMMAGEMENT:BR_VARI_SEUIL_ENDOMMAGEMENT+5)  = SigmaR
                vip(BR_VARI_SEUIL_ENDOMMAGEMENT+6)                              = sigdp
                vip(BR_VARI_RAG_ENDOMMAGEMENT:BR_VARI_RAG_ENDOMMAGEMENT+2)      = Dommage_Rag
                vip(BR_VARI_EPSI_VISC_RAG:BR_VARI_EPSI_VISC_RAG+5)              = EpsiVRAG(1:6)
                !
                vip(BR_VARI_LOI_INTEGRE)=max(param_br%loi_integre*1.0, vim(BR_VARI_LOI_INTEGRE))
            endif
        else
            ! Si calcul par perturbation ou fluage on met seulement à jour sigp
            ! On n'ajoute ni la pression de gel ni la pression capillaire
            sigp = TenseurVecteurAster( TSigma )
        endif
        ! Dans tous les cas on met grd_press%EpsiVRAG à jour, ce n'est utilisé que dans le fluage
        grd_press%EpsiVRAG = EpsiVRAG
        !
    end subroutine BR_Mecanique


    subroutine BR_Mecanique_Fluage(epsm, deps, vim, mater_br, param_br, &
                                   sigp, vip, dsidep, iret )
        implicit none
        !
#include "asterfort/assert.h"
        real(kind=8),               intent(in)      :: epsm(6), deps(6), vim(*)
        type(beton_rag_materiau),   intent(in)      :: mater_br
        type(beton_rag_parametres), intent(in)      :: param_br
        integer, intent(inout)                      :: iret
        !
        real(kind=8), intent(out) :: sigp(6)
        real(kind=8), intent(out) :: vip(*)
        real(kind=8), intent(out) :: dsidep(6, 6)
        !
        ! ------------------------------------------------------------------------------------------
        !
        integer, parameter  :: nbequa=30
        real(kind=8)        :: y0(nbequa), dy0(nbequa), resu(nbequa*2), ynorme(nbequa)
        !
        real(kind=8) :: epsmeca(6)=0.0d0, epsflua(6)=0.0d0, epsanel(6)=0.0d0, epsvrag(6)=0.0d0
        type(beton_rag_pression) :: grandeur_press
        !
        ! ------------------------------------------------------------------------------------------
        ! Déformation
        y0(1:6) = epsm
        ! Température (-)
        y0(7)   = param_br%temperm
        ! Hydratation (-)
        y0(8)   = param_br%hydratm
        ! Séchage (-)
        y0(9)   = param_br%sechagm
        ! Variables internes (-) liées au fluage
        y0(10:16) = vim(BR_VARI_EPSI_FLUAGE:BR_VARI_EPSI_FLUAGE+6)
        y0(17:23) = vim(BR_VARI_EPSI_FLUAGE_INTERNE:BR_VARI_EPSI_FLUAGE_INTERNE+6)
        ! Avancement chimique
        y0(24)    = vim(BR_VARI_AVANCEMENT_CHIMIQUE)
        !
        y0(25:30) = vim(BR_VARI_EPSI_VISC_RAG:BR_VARI_EPSI_VISC_RAG+5)
        !
        ! Pas de calcul de fluage avec perturbation : erreur développeur
        if ( param_br%perturbation ) then
            write(*,*) 'Pas encore possible de faire appel au fluage avec perturbation'
            ASSERT( .FALSE. )
        endif
        ! Vitesse de déformation
        dy0(1:6) = deps/param_br%dtemps
        ! Vitesse de la Température
        dy0(7)   = param_br%dtemper/param_br%dtemps
        ! Vitesse d'Hydratation
        dy0(8)   = param_br%dhydrat/param_br%dtemps
        ! Vitesse de Séchage
        dy0(9)   = param_br%dsechag/param_br%dtemps
        ! Pression de gel et pression capillaire
        grandeur_press = beton_rag_grd(epsm, mater_br, y0(24), y0(9))
        ! Normalisation des équations : comparaison à 'errmax 1.0e-06 par défaut'
        ynorme(1:6)   = 1.00d-06
        ynorme(7)     = 0.10d+00
        ynorme(8)     = 0.10d+00
        ynorme(9)     = 0.10d+00
        ynorme(10:16) = 1.00d-06
        ynorme(17:23) = 1.00d-06
        ynorme(24)    = 1.00d-06
        ynorme(25:30) = 1.00d-06
        !
        call BR_rk5adp(nbequa, mater_br, param_br, grandeur_press, vim, y0, dy0, ynorme, resu, iret)
        if (iret .ne. 0) goto 999
        !
        ! Si calcul du résidu, on met à jour les variables internes du fluage
        if ( param_br%resi ) then
            vip(BR_VARI_EPSI_FLUAGE:BR_VARI_EPSI_FLUAGE+6)                 = resu(10:16)
            vip(BR_VARI_EPSI_FLUAGE_INTERNE:BR_VARI_EPSI_FLUAGE_INTERNE+6) = resu(17:23)
            vip(BR_VARI_AVANCEMENT_CHIMIQUE)                               = resu(24)
            vip(BR_VARI_EPSI_VISC_RAG:BR_VARI_EPSI_VISC_RAG+5)             = resu(25:30)
            !
            vip(BR_VARI_LOI_INTEGRE)=max(param_br%loi_integre*1.0, vim(BR_VARI_LOI_INTEGRE))
        endif
        ! Déformations : Thermique, Hydratation
        if ( param_br%istemper ) then
            epsanel(1:3) = -mater_br%alpha*(param_br%temperp - param_br%temperref)
        endif
        if ( param_br%ishydrat ) then
            epsanel(1:3) = epsanel(1:3) + mater_br%bendo*param_br%hydratp
        endif
        ! Déformations de fluage
        epsflua = VecteurDeviaSpher( resu(10:15), resu(16) )
        ! Déformation visqueuse de la RAG
        epsvrag = resu(25:30)
        ! déformation
        ! Pression de gel
        grandeur_press = beton_rag_grd(epsm, mater_br, resu(24), resu(9))
        ! Déformation mécanique
        epsmeca = epsm + epsanel - epsflua - epsvrag
        call BR_Mecanique(epsmeca, deps, vim, mater_br, param_br, grandeur_press, sigp, vip, dsidep)
    999 continue
    end subroutine BR_Mecanique_Fluage



    subroutine beton_rag_mecanique_fluage(mater_br, param_br, grd_press, vim, &
                                          dt, yy0, dy0, dyy, decoup)
        implicit none
#include "asterf_types.h"
        !
        type(beton_rag_materiau),   intent(in) :: mater_br
        type(beton_rag_parametres), intent(in) :: param_br
        type(beton_rag_pression),   intent(inout) :: grd_press
        real(kind=8),  intent(in)    :: vim(*)
        real(kind=8),  intent(in)    :: dt
        real(kind=8),  intent(in)    :: yy0(*)
        real(kind=8),  intent(in)    :: dy0(*)
        real(kind=8),  intent(out)   :: dyy(*)
        aster_logical, intent(inout) :: decoup
        !
        ! ------------------------------------------------------------------------------------------
        !
        real(kind=8)   :: deps(6), sigma_m(6), vip(1), dsidep(6, 6), epsflua(6)
        real(kind=8)   :: vimloc(BR_VARI_NOMBRE)
        real(kind=8)   :: epsmeca(6) = 0.0d0 , epsanel(6) = 0.0d0, epsvrag(6)=0.0d0
        real(kind=8)   :: k1, n1, k2, n2, sigma_sph, vaux1, xx1
        type(SpheDev)  :: TSpheDev
        type(beton_rag_parametres) :: param_br_loc
        integer, parameter :: iflu = 10
        ! ------------------------------------------------------------------------------------------
        ! On ne met pas à jour les vip(*) et dsidep(*) de la mécanique.
        param_br_loc = param_br
        param_br_loc%fluage = .true.
        ! Intégration : Déformations
        dyy(1:6) = dy0(1:6)
        ! Intégration : Température, Hydratation, Séchage
        dyy(7) = dy0(7)
        dyy(8) = dy0(8)
        dyy(9) = dy0(9)
        ! Déformations : Thermique, Hydratation
        if ( param_br%istemper ) then
            epsanel(1:3) = -mater_br%alpha*(yy0(7) - param_br%temperref)
        endif
        if ( param_br%ishydrat ) then
            epsanel(1:3) = epsanel(1:3) + mater_br%bendo*yy0(8)
        endif
        ! Déformations de fluage
        epsflua = VecteurDeviaSpher( yy0(iflu:iflu+5) , yy0(iflu+6) )
        ! Déformation visqueuse de la RAG
        epsvrag(1:6) = yy0(25:30)
        ! Pression de gel et pression capillaire
        grd_press = beton_rag_grd(yy0(1:6), mater_br, yy0(24), yy0(9))
        ! Déformation mécanique
        epsmeca = yy0(1:6) + epsanel - epsflua - epsvrag
        deps    = 0.0d0
        vimloc(:) = vim(1:BR_VARI_NOMBRE)
        call BR_Mecanique(epsmeca, deps, vimloc, mater_br, param_br_loc, grd_press, &
                          sigma_m, vip, dsidep)
        !
        ! Déformation visqueuse de la RAG
        dyy(25:30) = 0.0d0
        if ( param_br%loi_integre == 3 ) then
            ! Calcul de EpsiVRAG par perturbation de la déformation
            epsvrag = grd_press%EpsiVRAG
            ! La perturbation est dans la direction de l'incrément de déformation
            deps(1:6) = BRSigne( 1.0d-06, dy0(1:6) )
            call BR_Mecanique(epsmeca, deps, vimloc, mater_br, param_br_loc, grd_press, &
                              sigma_m, vip, dsidep)
            dyy(25:30) = abs(grd_press%EpsiVRAG - epsvrag)/1.0D-06
        endif
        !
        TSpheDev = DeviaSpher( VecteurAsterVecteur(sigma_m) )
        ! Fluage déviatorique
        sigma_m = TSpheDev%deviateur
        k1 = mater_br%fluage_dev%k1
        k2 = mater_br%fluage_dev%k2
        n1 = mater_br%fluage_dev%n1
        n2 = mater_br%fluage_dev%n2
        dyy(iflu:iflu+5)    = (sigma_m(1:6) - k1*yy0(iflu+7:iflu+12))/n1
        dyy(iflu+7:iflu+12) = (k2*(yy0(iflu:iflu+5) - yy0(iflu+7:iflu+12)) &
                               - k1*yy0(iflu+7:iflu+12))/n2 + dyy(iflu:iflu+5)
        ! Fluage sphérique
        sigma_sph = TSpheDev%spherique
        k1 = mater_br%fluage_sph%k1
        k2 = mater_br%fluage_sph%k2
        n1 = mater_br%fluage_sph%n1
        n2 = mater_br%fluage_sph%n2
        dyy(iflu+6)  = (sigma_sph - k1*yy0(iflu+13))/n1
        dyy(iflu+13) = (k2*(yy0(iflu+6) - yy0(iflu+13)) - k1*yy0(iflu+13))/n2 + dyy(iflu+6)
        !
        ! Avancement chimique
        dyy(24) = 0.0d0
        if ( param_br%loi_integre == 3 ) then
            if ( (yy0(9) > mater_br%gel%sr0) .and. &
                 (yy0(9) > yy0(24)) ) then
                vaux1 = (yy0(7)-mater_br%gel%Tref)/(yy0(7)+273.15)/(mater_br%gel%Tref+273.15)
                xx1   = mater_br%gel%ear*vaux1
                vaux1 = mater_br%gel%alpha0 * exp( min(max(-100.0,xx1),100.0) )
                dyy(24) = vaux1 * (yy0(9)-mater_br%gel%sr0)*(yy0(9)-yy0(24))/(1.0-mater_br%gel%sr0)
            endif
        endif
        !
    end subroutine beton_rag_mecanique_fluage


    subroutine BR_rk5adp(nbeq, mater_br, param_br, grd_press, vim, y0, dy0, ynorme, resu, iret)
        ! ------------------------------------------------------------------------------------------
        !
        !          INTÉGRATION PAR MÉTHODE DE RUNGE KUTTA D'ORDRE 5
        !
        !  appel à rk5app
        !  calcul de l'erreur
        !  adaptation du pas de temps
        !
        ! ------------------------------------------------------------------------------------------
        !
        !  IN
        !     nbeq          : nombre d'équations
        !     mater_br      : matériau béton rag
        !     param_br      : paramètres béton_rag
        !     y0            : valeurs à t
        !     dy0           : vitesse à t
        !     ynorme        : vecteur de normalisation des équations
        !
        !  OUT
        !     resu     : résultat de l'intégration
        !        resu(1:nbeq)            : variables intégrées
        !        resu(nbeq+1:2*nbeq)     : dérivées a t+dt
        !     iret     : redécoupage du pas de temps global
        !
        ! ------------------------------------------------------------------------------------------
        implicit none
#include "asterf_types.h"
        integer          :: nbeq
        type(beton_rag_materiau),   intent(in) :: mater_br
        type(beton_rag_parametres), intent(in) :: param_br
        type(beton_rag_pression),   intent(inout) :: grd_press
        real(kind=8), intent(in)  :: vim(*)
        real(kind=8), intent(in)  :: y0(nbeq)
        real(kind=8), intent(in)  :: dy0(nbeq)
        real(kind=8), intent(in)  :: ynorme(nbeq)
        real(kind=8), intent(out) :: resu(2*nbeq)
        integer,      intent(out) :: iret
        !
        integer :: nbbou, ii
        real(kind=8) :: t9, dt9, y9(nbeq), erreur, xbid1, solu(3*nbeq)
        aster_logical :: decoup
        !
        real(kind=8) :: puplus, pumoin, creduc, cforce, coeffm, seuil, precis, grlog
        ! puissance pour augmenter le pas de temps
        parameter (puplus = -0.20d0)
        ! puissance pour diminuer le pas de temps
        parameter (pumoin = -0.25d0)
        ! coefficient de reduction sur la variation du pas de temps
        parameter (creduc =  0.90d0)
        ! coefficient de diminution du pas de temps en cas de forcage
        parameter (cforce =  0.30d0)
        ! augmentation maximale de pas de temps
        parameter (coeffm =  5.0d0)
        parameter (seuil  = (coeffm/creduc)**(1.0d0/puplus) )
        parameter (precis =  1.0d-08)
        parameter (grlog  =  1.0d+08)
        !
        ! ------------------------------------------------------------------------------------------
        !
        nbbou = 0
        t9  = param_br%instam
        dt9 = param_br%dtemps
        y9(:) = y0(:)
        ! on commence
    100 continue
        !
        ! dépassement du nombre d'itération maximum ==> découpage global
        if (nbbou .gt. param_br%nbdecp) then
            iret = 1
            goto 999
        endif
        decoup = ASTER_FALSE

        call BR_rk5app(nbeq, mater_br, param_br, grd_press, vim, dt9, y9, dy0, solu, decoup)
        nbbou = nbbou + 1
        ! découpage forcé
        if (decoup) then
            dt9 = cforce * dt9
            goto 100
        endif
        ! calcul de l'erreur
        erreur = 0.0d0
        do ii = 1, nbeq
            xbid1 = abs( solu(2*nbeq + ii)/ynorme(ii) )
            if (xbid1 .gt. grlog) then
                if (log10(xbid1) .gt. 100.0d0) then
                    ! découpage forcé
                    dt9 = cforce * dt9
                    goto 100
                endif
            endif
            erreur = erreur + (xbid1**2)
        enddo
        erreur = sqrt(erreur)/param_br%errmax
        if (erreur .gt. 1.0d0) then
            ! on ne converge pas ==> diminution du pas de temps
            xbid1 = creduc * dt9 * (erreur**pumoin)
            dt9 = max(0.10d0 * dt9, xbid1)
            goto 100
        else if (abs(t9 + dt9 - param_br%instam - param_br%dtemps) .gt. precis) then
            ! on a converge ==> augmentation du pas de temps
            nbbou = 0
            ! temps convergé
            t9 = t9 + dt9
            ! solution convergée
            y9(1:nbeq) = solu(1:nbeq)
            ! augmente le pas d'intégration dans la limite de coeffm
            if (erreur .gt. seuil) then
                dt9 = creduc * dt9 * (erreur**puplus)
            else
                dt9 = coeffm * dt9
            endif
            ! on ne peut pas dépasser param_br%instam + param_br%dtemps
            if (t9 + dt9 .gt. param_br%instam + param_br%dtemps) then
                dt9 = param_br%instam + param_br%dtemps - t9
            endif
            goto 100
        endif
        ! résultat
        resu = solu(1:2*nbeq)
        999 continue
    end subroutine BR_rk5adp


    subroutine BR_rk5app(nbeq, mater_br, param_br, grd_press, vim, dtemps, yinit, dyinit, &
                         solu, decoup)
        ! ------------------------------------------------------------------------------------------
        !
        !          INTÉGRATION PAR MÉTHODE DE RUNGE KUTTA D'ORDRE 5
        !
        !  intégration des équations
        !  dérivée au temps t + dt
        !  calcul de l'erreur pour chaque équation
        !
        ! ------------------------------------------------------------------------------------------
        !
        ! IN
        !   nbeq          : nombre d'équations
        !   mater_br      : matériau béton rag
        !   param_br      : paramètres béton_rag
        !   dtemps        : incrément de temps
        !   yinit         : valeurs à t
        !   dyinit        : vitesse à t
        !
        ! OUT
        !  solu        : résultat de l'intégration
        !        solu(1:nbeq)            : variables intégrées
        !        solu(nbeq+1:2*nbeq)     : dérivées a t+dt
        !        solu(2*nbeq+1:3*nbeq)   : erreur
        !  decoup      : force le découpage
        !
        ! ------------------------------------------------------------------------------------------
        implicit none
#include "asterf_types.h"
        integer, intent(in)      :: nbeq
        real(kind=8), intent(in) :: dtemps, yinit(nbeq), dyinit(nbeq), vim(*)
        type(beton_rag_materiau),   intent(in) :: mater_br
        type(beton_rag_parametres), intent(in) :: param_br
        type(beton_rag_pression),   intent(inout) :: grd_press
        real(kind=8), intent(out) :: solu(3*nbeq)
        aster_logical, intent(inout) :: decoup
        !
        ! niveau du runge-kutta
        integer :: nivrk, nn, niv, ii
        parameter  (nivrk=6)
        real(kind=8) :: yy(nbeq), rr(nbeq, nivrk)
        ! tables de cash-karp
        real(kind=8) :: tabc(nivrk), tabe(nivrk), tabb(nivrk, nivrk)
        !
        ! initialisation des tables de cash-karp
        ! taba : ( 0.0 , 0.2 , 0.3, 0.6, 1.0 , 7/8 ). remarque  taba(i)= somme( tabb(i,:) )
        data tabc/9.78835978835978781642524d-02, 0.0d0, 4.02576489533011283583619d-01, &
            2.10437710437710451261140d-01, 0.0d0, 2.89102202145680386990989d-01/
        data tabe/1.02177372685185188783130d-01, 0.0d0, 3.83907903439153430635855d-01, &
            2.44592737268518517490534d-01, 1.93219866071428561515866d-02, 0.25d0/
        !
        tabb(:,:) = 0.0d0
        tabb(2, 1) = 0.20d0
        tabb(3, 1:2) = (/ 3.0d0/40.0d0, 9.0d0/40.0d0 /)
        tabb(4, 1:3) = (/ 3.0d0/10.0d0, -9.0d0/10.0d0, 6.0d0/5.0d0 /)
        tabb(5, 1:4) = (/ -11.0d0/54.0d0, 2.50d0, -70.0d0/27.0d0, 35.0d0/27.0d0 /)
        tabb(6, 1:5) = (/ 1631.0d0/55296.0d0, 175.0d0/512.0d0, 575.0d0/13824.0d0,44275.0d0&
                        /110592.0d0, 253.0d0/4096.0d0 /)
        !
        ! niveaux de RK
        do niv = 1, nivrk
            do ii = 1, nbeq
                yy(ii) = yinit(ii)
                do nn = 1, niv - 1
                    yy(ii) = yy(ii) + tabb(niv,nn)*dtemps*rr(ii,nn)
                enddo
            enddo
            call beton_rag_mecanique_fluage(mater_br, param_br, grd_press, vim, dtemps, &
                                            yy, dyinit, rr(1,niv), decoup)
            if (decoup) goto 999
        enddo
        !
        do ii = 1, nbeq
            ! intégration
            solu(ii) = yinit(ii)
            ! dérivée à t+dt
            solu(nbeq+ii) = rr(ii,5)
            ! erreur
            solu(2*nbeq+ii) = 0.0d0
            do niv = 1, nivrk
                solu(ii) = solu(ii) + tabc(niv) * rr(ii,niv)*dtemps
                solu(2*nbeq+ii) = solu(2*nbeq+ii) + (tabc(niv)- tabe(niv))*rr(ii,niv)*dtemps
            enddo
        enddo
        !
        999 continue
    end subroutine BR_rk5app


end module beton_rag_module
