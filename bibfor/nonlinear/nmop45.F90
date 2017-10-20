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
!
subroutine nmop45(eigsol, defo, mod45, modes, modes2, ds_posttimestep_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/elmddl.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/onerrf.h"
#include "asterfort/vecini.h"
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
integer           , intent(in) :: defo
character(len=4)  , intent(in) :: mod45
character(len=8)  , intent(in) :: modes, modes2
character(len=19) , intent(in) :: eigsol
type(NL_DS_PostTimeStep), optional, intent(in) :: ds_posttimestep_
!
! ======================================================================
!        ROUTINE DE CALCUL DE CRITERE DE STABILITE VIA UNE RESOLUTION
!        DE GEP (PARTAGEE AVEC OP0045).
!-----------------------------------------------------------------------
!   IN : EIGSOL : SD EIGENSOLVER CONTENANT LES PARAMETRES DU PB MODAL
!   IN : DEFO   : TYPE DE DEFORMATIONS
!                0            PETITES DEFORMATIONS (MATR. GEOM.)
!                1            GRANDES DEFORMATIONS (PAS DE MATR. GEOM.)                  
!   IN : MOD45  : TYPE DE CALCUL AU SENS NMOP45: VIBR OU FLAM
!   IN : MODES  : NOM UTILISATEUR DU CONCEPT MODAL PRODUIT
!   IN : MODES2 : NOM UTILISATEUR D'UN SECOND CONCEPT MODAL PRODUIT (SI
!                 ANALYSE DE STABILITE (NSTA.NE.0)
!-----------------------------------------------------------------------
!
!
    integer :: nbpari, nbparr, nbpark
    parameter (nbpari=8,nbparr=16,nbpark=3)
!
    integer           :: iret, ibid, npivot, neqact, mxresf, nblagr,nbddl, nbddl2, un, lresur
    integer           :: nconv, ifm, niv, neq, lraide, eddl, eddl2, jstab, iauxr
    integer           :: nsta, nddle
    real(kind=8)      :: omemin, omemax, omeshi, vpinf, vpmax, r8bid, csta
    complex(kind=8)   :: cbid
    character(len=4)  :: mod45b
    character(len=8)  :: method
    character(len=16) :: typcon, typco2, k16bid
    character(len=19) :: matopa, solveu, raide
    character(len=24) :: k24bid, vecblo, veclag, vecrer, vecrei, vecrek, vecvp, vecstb
    character(len=24) :: vecedd, vecsdd
    aster_logical     :: lcomod, checksd
    mpi_int           :: mpibid
    aster_logical     :: flage
!
! DIVERS
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
    cbid=(0.d0,0.d0)
    nconv=0 
    nsta  = 0
    nddle = 0
    if (present(ds_posttimestep_)) then
        nddle  = ds_posttimestep_%stab_para%nb_dof_excl
        nsta   = ds_posttimestep_%stab_para%nb_dof_stab
    endif
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
    call vpvers(eigsol, modes2, checksd)

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

! --- LECTURE TYPE DE SOLVEUR MODAL
    call vpleci(eigsol, 'K', 6, k24bid, r8bid, ibid)
    method=''
    method=trim(k24bid)
    if (((mod45(1:4).eq.'FLAM').and.(defo.eq.0)).or.(mod45(1:4).ne.'FLAM')) then
! ========================================================================
! --- FLAMBEMENT AVEC MATRICE GEOMETRIQUE OU DYNAMIQUE TOUT CAS DE FIGURE
! ======================================================================== 
!
! ------ CALCUL MODAL STANDARD
!
        mod45b=mod45
        select case (method)
        case('SORENSEN')
            call vpcals(eigsol, vecrer, vecrei, vecrek, vecvp,&
                    matopa, mxresf, neqact, nblagr, omemax,&
                    omemin, omeshi, solveu, vecblo, veclag,&
                    cbid, npivot, flage, nconv, vpinf, vpmax, mod45b,&
                    k24bid, k24bid, ibid, K24bid, ibid, r8bid)
        case default
            ASSERT(.false.)
        end select
!
! ------ POST-TRAITEMENTS SANS VERIFICATION (NI STURM, NI SEUIL, NI BANDE) +
! ------ PAS DE NETTOYAGE EXPLICITE DES OBJETS JEVEUX GLOBAUX LIES AU MODAL
!
        mod45b=mod45
        call vppost(vecrer, vecrei, vecrek, vecvp, nbpark,&
                nbpari, nbparr, mxresf, nconv, nblagr,&
                ibid, modes, typcon, k16bid, eigsol,&
                matopa, matopa, solveu, vecblo, veclag,&
                flage, ibid, ibid, mpibid, mpibid,&
                omemax, omemin, vpinf, vpmax, lcomod, mod45b)

    else
! ========================================================================
! --- FLAMBEMENT SANS MATRICE GEOMETRIQUE
! ========================================================================

!
! ------ PRETRAITEMENTS
!
        call jeveuo(raide(1:19)//'.&INT', 'L', lraide)
        neq = zi(lraide+2)
        vecstb='&&NMOP45.VEC.STAB'
        call wkvect(vecstb,'V V R', neq, jstab)

        vecedd='&&NMOP45.POSI.EDDL'
        call wkvect(vecedd,'V V I', neq, eddl)
        if (nddle.ne.0) then
            call elmddl(raide, 'DDL_EXCLUS    ', neq, ds_posttimestep_%stab_para%list_dof_excl,&
                        nddle, nbddl, zi(eddl))
        else
            nbddl = 0
        endif
        vecsdd='&&NMOP45.POSI.SDDL'
        call wkvect(vecsdd, 'V V I', neq, eddl2)
        if (nsta.ne.0) then
            call elmddl(raide, 'DDL_STAB      ', neq, ds_posttimestep_%stab_para%list_dof_stab,&
                        nsta, nbddl2, zi(eddl2))
        else
            nbddl2 = 0
        endif
!
! ------ CALCUL MODAL ADAPTE
        mod45b='SOR1'
        select case (method)
        case('SORENSEN')
            call vpcals(eigsol, vecrer, vecrei, vecrek, vecvp,&
                    matopa, mxresf, neqact, nblagr, omemax,&
                    omemin, omeshi, solveu, vecblo, veclag,&
                    cbid, npivot, flage, nconv, vpinf, vpmax, mod45b,&
                    vecstb, vecedd, nbddl, vecsdd, nbddl2, csta)
        case default
            ASSERT(.false.)
        end select
!
! ------ POST-TRAITEMENTS SANS VERIFICATION (NI STURM, NI SEUIL, NI BANDE) +
! ------ PAS DE NETTOYAGE EXPLICITE DES OBJETS JEVEUX GLOBAUX LIES AU MODAL

!
        mod45b=mod45
        call vppost(vecrer, vecrei, vecrek, vecvp, nbpark,&
                nbpari, nbparr, mxresf, nconv, nblagr,&
                ibid, modes, typcon, k16bid, eigsol,&
                matopa, matopa, solveu, vecblo, veclag,&
                flage, ibid, ibid, mpibid, mpibid,&
                omemax, omemin, vpinf, vpmax, lcomod, mod45b)
        if (nsta .ne. 0) then
            typco2='MODE_STAB'
            mod45b='STAB'
            un=1
            call jeveuo(vecrer, 'E', lresur)
            call jelira(vecrer, 'LONMAX', iauxr)
            call vecini(iauxr, csta, zr(lresur))
            call vppost(vecrer, vecrei, vecrek, vecstb, nbpark,&
                    nbpari, nbparr, un, un, nblagr,&
                    ibid, modes2, typco2, k16bid, eigsol,&
                    matopa, matopa, solveu, vecblo, veclag,&
                    flage, ibid, ibid, mpibid, mpibid,&
                    omemax, omemin, vpinf, vpmax, lcomod, mod45b)
        endif
        call jedetr(vecstb)
        call jedetr(vecedd)
        call jedetr(vecsdd)

    endif
!
 80 continue
!
! ---  ON AJUSTE LA VALEURS NFREQ DE LA SD EIGENSOLVER
    call vpecri(eigsol, 'I', 1, k24bid, r8bid, nconv)
!
! --- NETTOYAGE EXPLICITE DES OBJETS JEVEUX GLOBAUX
    call jedetr(vecblo)
    call jedetr(veclag)
    if (iret.ne.0) then
        call detrsd('MATR_ASSE', matopa)
        call jedetr(matopa(1:19)//'.&INT')
        call jedetr(matopa(1:19)//'.&IN2')
    else
        call jedetr(vecrer)
        call jedetr(vecrei)
        call jedetr(vecrek)
        call jedetr(vecvp)
    endif      
!
    call jedema()
!
!     ------------------------------------------------------------------
!
!     FIN DE NMOP45
!
end subroutine
