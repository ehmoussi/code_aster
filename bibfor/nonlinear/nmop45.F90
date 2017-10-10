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

subroutine nmop45(eigsol, defo, mod45, ddlexc, nddle, modes, modes2, ddlsta, nsta)
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/elmddl.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/onerrf.h"
#include "asterfort/vpcals.h"
#include "asterfort/vpecri.h"
#include "asterfort/vpini1.h"
#include "asterfort/vpini2.h"
#include "asterfort/vpleci.h"
#include "asterfort/vppara.h"
#include "asterfort/vppost.h"
#include "asterfort/vpsor1.h"
#include "asterfort/vpvers.h"
#include "asterfort/wkvect.h"
!
    integer           , intent(in) :: defo, nddle, nsta
    character(len=4)  , intent(in) :: mod45
    character(len=8)  , intent(in) :: modes, modes2
    character(len=19) , intent(in) :: eigsol
    character(len=24) , intent(in) :: ddlexc, ddlsta
!
! ======================================================================
!        MODE_ITER_SIMULT
!        RECHERCHE DE MODES PAR ITERATION SIMULTANEE EN SOUS-ESPACE
!-----------------------------------------------------------------------
!        - POUR LE PROBLEME GENERALISE AUX VALEURS PROPRES :
!                         2
!                        L (M) Y  + (K) Y = 0
!
!          LES MATRICES (K) ET (M) SONT REELLES SYMETRIQUES
!          LES VALEURS PROPRES ET VECTEURS PROPRES SONT REELS
!          PERIMETRE ACTUEL: GEP SYMETRIQUE REEL AVEC SORENSEN
!          SEQUENTIEL AU NIVEAU SOLVEUR MODAL, PAS DE POST-VERIFICATION
!-----------------------------------------------------------------------
!   IN : EIGSOL : SD EIGENSOLVER CONTENANT LES PARAMETRES DU PB MODAL
!   IN : DEFO   : TYPE DE DEFORMATIONS
!                0            PETITES DEFORMATIONS (MATR. GEOM.)
!                1            GRANDES DEFORMATIONS (PAS DE MATR. GEOM.)                  
!   IN : MOD45  : TYPE DE CALCUL AU SENS NMOP45: VIBR OU FLAM
!   IN : DDLEXC : OBJET JEVEUX VECTEUR POSITION DES DDLS BLOQUES
!   IN : NDDLE  : TAILLE DE CE VECTEUR
!   IN : MODES  : NOM UTILISATEUR DU CONCEPT MODAL PRODUIT
!   IN : MODES2 : NOM UTILISATEUR D'UN SECOND CONCEPT MODAL PRODUIT (SI
!                 ANALYSE DE STABILITE (NSTA.NE.0)
!   IN : DDLSTA : OBJET JEVEUX VECTEUR DES DDLS DE STABILITE A EXCLURE
!                 DU PB MODAL
!   IN : NSTA   : TAILLE DE CE VECTEUR
!-----------------------------------------------------------------------
!
!
    integer :: nbpari, nbparr, nbpark
    parameter (nbpari=8,nbparr=16,nbpark=3)
!
    integer           :: iret, ibid, npivot, neqact, mxresf, nblagr
    integer           :: nconv, ifm, niv
    real(kind=8)      :: omemin, omemax, omeshi, vpinf, vpmax, r8bid
    complex(kind=8)   :: cbid
    character(len=8)  :: method
    character(len=16) :: typcon, k16bid
    character(len=19) :: matopa, solveu, raide
    character(len=24) :: k24bid, vecblo, veclag, vecrer, vecrei, vecrek, vecvp
    aster_logical     :: lbid, lcomod, checksd
    mpi_int           :: mpibid
    aster_logical     :: flage
!
! DIVERS
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
    cbid=(0.d0,0.d0)
    nconv=0 
!
! --- CALCUL MODAL NON PARALLELISE (SEUL EVENTUELLEMENT LE SOLVEUR LINEAIRE SOUS-JACENT)
!
    lcomod=.false.
!
! --- LECTURE DES PARAMETRES SOLVEUR LINEAIRE
!
    call vpleci(eigsol, 'K', 2, k24bid, r8bid, ibid)
    raide=trim(k24bid)
    call dismoi('SOLVEUR', raide, 'MATR_ASSE', repk=solveu)
    if ((solveu(1:8) .ne. '&&NUME91') .and. (solveu(1:8) .ne. '&&DTM&&&')) then
        solveu='&&OP00XX.SOLVER'
    endif
!
! --- VERIFICATION FR LA COHERENCE DE LA SD EIGSOL ET DES OBJETS SOUS-JACENTS
!
    checksd=.true. 
    call vpvers(eigsol, modes, checksd)

! ---  TRAITEMENTS NUMERIQUES (SOLVEUR LINEAIRE, LAGRANGE, MODES RIGIDES, 
! ---  BORNES DE TRAVAIL EFFECTIVES, CALCUL DU NOMBRE DE MODES, FACTO. MATRICE SHIFTEE
! ---  DETERMINATION TAILLE DE L'ESPACE DE PROJECTION)
    if (mod45(1:4) .eq. 'VIBR') then
      typcon = 'MODE_MECA'
    else
      typcon = 'MODE_FLAMB'
    endif
    vecblo='&&NMOP45.POSITION.DDL'
    veclag='&&NMOP45.DDL.BLOQ.CINE'
    matopa='&&NMOP45.DYN_FAC_C '
    call vpini1(eigsol, modes, solveu, typcon, vecblo, veclag, k24bid, matopa, matopa, iret,&
                nblagr, neqact, npivot, ibid, omemax, omemin, omeshi, cbid, mod45)
    if (iret.ne.0) goto 80
!
! --- CREATION ET INITIALISATION DES SDS RESULTATS
!
    vecrer = '&&NMOP45.RESU_'
    vecrei = '&&NMOP45.RESU_I'
    vecrek = '&&NMOP45.RESU_K'
    vecvp  = '&&NMOP45.VECTEUR_PROPRE'
    call vpini2(eigsol, lcomod, ibid, ibid, nbpark,&
                nbpari, nbparr, vecrer, vecrei, vecrek, vecvp, mxresf)
!
! --- CALCUL MODAL PROPREMENT DIT
!
    call vpleci(eigsol, 'K', 6, k24bid, r8bid, ibid)
    method=''
    method=trim(k24bid)
    select case (method)
    case('SORENSEN')
        call vpcals(eigsol, vecrer, vecrei, vecrek, vecvp,&
                    matopa, mxresf, neqact, nblagr, omemax,&
                    omemin, omeshi, solveu, vecblo, veclag,&
                    cbid, npivot, flage, nconv, vpinf, vpmax, mod45)
    case default
        ASSERT(.false.)
    end select
!
! --- POST-TRAITEMENTS SANS VERIFICATION (NI STURM, NI SEUIL, NI BANDE) +
! --- NETTOYAGE EXPLICITE DES OBJETS JEVEUX GLOBAUX LIES AU MODAL
!
    call vppost(vecrer, vecrei, vecrek, vecvp, nbpark,&
                nbpari, nbparr, mxresf, nconv, nblagr,&
                ibid, modes, typcon, k16bid, eigsol,&
                matopa, matopa, solveu, vecblo, veclag,&
                flage, ibid, ibid, mpibid, mpibid,&
                omemax, omemin, vpinf, vpmax, lcomod, mod45)
!
    if (mod45 .eq. 'FLAM') then
!
        if (defo .eq. 0) then
!         ancien vpsorn
        else
            write(ifm,*)'<NMOP45> A FAIRE 1'
            ASSERT(.false.)
!            call wkvect('&&NMOP45.POSI.EDDL', 'V V I', neq*mxddl, eddl)
!            if (nddle .ne. 0) then
!                call jeveuo(ddlexc, 'L', jexx)
!                call elmddl(matrig, 'DDL_EXCLUS    ', neq, zk8(jexx), nddle,&
!                            nbddl, zi(eddl))
!            else
!                nbddl = 0
!            endif
!
!            call wkvect('&&NMOP45.POSI.SDDL', 'V V I', neq*mxddl, eddl2)
!
!            if (nsta .ne. 0) then
!                call jeveuo(ddlsta, 'L', jest)
!                call elmddl(matrig, 'DDL_STAB      ', neq, zk8(jest), nsta,&
!                            nbddl2, zi(eddl2))
!            else
!                nbddl2 = 0
!            endif
!
!            redem = 0
!
!            call vpsor1(lmatra, neq, nbvect, nfreq, tolsor,&
!                        vect_propre, resid, zr(lworkd), zr(lworkl), lonwl,&
!                        select, zr(ldsor), omeshi, zr(laux), zr(lworkv),&
!                        zi(lprod), zi(lddl), zi(eddl), nbddl, neqact,&
!                        maxitr, ifm, niv, priram, alpha,&
!                        omecor, nconv, flage, solveu, nbddl2,&
!                        zi(eddl2), vect_stabil, csta, redem)
!
        endif
    else
!      ancien vpsorn
    endif

    if (nsta .ne. 0) then
            write(ifm,*)'<NMOP45> A FAIRE 2'
            ASSERT(.false.)
!
!        typco2 = 'MODE_STAB'
!
!        call vppara(modes2, typco2, knega, lraide, lmasse,&
!                    lamor, un, neq, un, omecor,&
!                    zi(lddl), zi(lprod), vect_stabil, [cbid], nbpari,&
!                    nparr, nbpark, nopara, 'STAB', resu_i,&
!                    [csta], resu_k, ktyp, .false._1, ibid,&
!                    ibid, k16bid, ibid)
!
    endif
!
 80 continue
!
! ---  ON AJUSTE LA VALEURS NFREQ DE LA SD EIGENSOLVER
    call vpecri(eigsol, 'I', 1, k24bid, r8bid, nconv)
    if (iret.ne.0) then 
      call jedetr(vecblo)
      call jedetr(veclag)
      call detrsd('MATR_ASSE', matopa)
    endif
!
    call jedema()
!
!     ------------------------------------------------------------------
!
!     FIN DE NMOP45
!
end subroutine
